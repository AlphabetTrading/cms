import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialReturnInput } from './dto/create-material-return.input';
import { MaterialReturnVoucher } from './model/material-return.model';
import { UpdateMaterialReturnInput } from './dto/update-material-return.input';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';
import { DocumentType } from 'src/common/enums/document-type';
import puppeteer from 'puppeteer-core';
import { format } from 'date-fns';

@Injectable()
export class MaterialReturnService {
  constructor(private prisma: PrismaService) {}

  async createMaterialReturn(
    createMaterialReturn: CreateMaterialReturnInput,
  ): Promise<MaterialReturnVoucher> {
    const lastMaterialReturnVoucher =
      await this.prisma.materialReturnVoucher.findFirst({
        select: {
          serialNumber: true,
        },
        orderBy: {
          createdAt: 'desc',
        },
      });
    let currentSerialNumber = 1;
    if (lastMaterialReturnVoucher) {
      currentSerialNumber =
        parseInt(lastMaterialReturnVoucher.serialNumber.split('/')[1]) + 1;
    }
    const serialNumber =
      'RTN/' + currentSerialNumber.toString().padStart(4, '0');

    const createdMaterialReturn =
      await this.prisma.materialReturnVoucher.create({
        data: {
          ...createMaterialReturn,
          serialNumber: serialNumber,
          items: {
            create: createMaterialReturn.items.map((item) => ({
              productVariantId: item.productVariantId,
              issueVoucherId: item.issueVoucherId,
              quantity: item.quantity,
              unitCost: item.unitCost,
              totalCost: item.totalCost,
            })),
          },
        },
        include: {
          items: {
            include: {
              issueVoucher: true,
              productVariant: {
                include: {
                  product: true,
                },
              },
            },
          },
          Project: true,
          receivedBy: true,
          returnedBy: true,
          receivingWarehouseStore: true,
        },
      });
    return createdMaterialReturn;
  }

  async getMaterialReturns({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.MaterialReturnVoucherWhereInput;
    orderBy?: Prisma.MaterialReturnVoucherOrderByWithRelationInput;
  }): Promise<MaterialReturnVoucher[]> {
    const materialReturns = await this.prisma.materialReturnVoucher.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        items: {
          include: {
            issueVoucher: true,
            productVariant: {
              include: {
                product: true,
              },
            },
          },
        },
        Project: true,
        receivedBy: true,
        returnedBy: true,
        receivingWarehouseStore: true,
      },
    });
    return materialReturns;
  }

  async getMaterialReturnCountByStatus({
    where,
  }: {
    where?: Prisma.MaterialReturnVoucherWhereInput;
  }): Promise<any> {
    const statusCounts = await this.prisma.materialReturnVoucher.groupBy({
      by: ['status'],
      where,
      _count: {
        status: true,
      },
    });

    let counts = { COMPLETED: 0, DECLINED: 0, PENDING: 0 };

    counts = statusCounts.reduce((acc, { status, _count }) => {
      acc[status] = _count.status;
      return acc;
    }, counts);

    const documentTransaction = new DocumentTransaction();
    documentTransaction.approvedCount = counts.COMPLETED;
    documentTransaction.declinedCount = counts.DECLINED;
    documentTransaction.pendingCount = counts.PENDING;
    documentTransaction.type = DocumentType.MATERIAL_RETURN;

    return documentTransaction;
  }

  async getMaterialReturnById(
    materialReturnId: string,
  ): Promise<MaterialReturnVoucher | null> {
    const materialReturn = await this.prisma.materialReturnVoucher.findUnique({
      where: { id: materialReturnId },
      include: {
        items: {
          include: {
            issueVoucher: true,
            productVariant: {
              include: {
                product: true,
              },
            },
          },
        },
        Project: true,
        receivedBy: true,
        returnedBy: true,
        receivingWarehouseStore: true,
      },
    });

    return materialReturn;
  }

  async updateMaterialReturn(
    input: UpdateMaterialReturnInput,
  ): Promise<MaterialReturnVoucher> {
    const { id: materialReturnId, ...updateData } = input;

    return await this.prisma.$transaction(async (prisma) => {
      const existingMaterialReturn =
        await prisma.materialReturnVoucher.findUnique({
          where: { id: materialReturnId },
        });

      if (!existingMaterialReturn) {
        throw new NotFoundException('Material Return not found');
      }

      const itemUpdateConditions = updateData.items.map((item) => ({
        productVariantId: item.productVariantId,
      }));

      const updatedMaterialReturn = await prisma.materialReturnVoucher.update({
        where: { id: materialReturnId },
        data: {
          ...updateData,
          items: {
            updateMany: {
              data: updateData.items,
              where: {
                OR: itemUpdateConditions,
              },
            },
          },
        },
        include: {
          items: {
            include: {
              issueVoucher: true,
              productVariant: {
                include: {
                  product: true,
                },
              },
            },
          },
          Project: true,
          receivedBy: true,
          returnedBy: true,
          receivingWarehouseStore: true,
        },
      });

      return updatedMaterialReturn;
    });
  }

  async deleteMaterialReturn(
    materialReturnId: string,
  ): Promise<MaterialReturnVoucher> {
    const existingMaterialReturn =
      await this.prisma.materialReturnVoucher.findUnique({
        where: { id: materialReturnId },
      });

    if (!existingMaterialReturn) {
      throw new NotFoundException('Material Return not found');
    }

    await this.prisma.materialReturnVoucher.delete({
      where: { id: materialReturnId },
    });

    return existingMaterialReturn;
  }

  async getMaterialReturnApprovers(projectId: string) {
    const approvers = await this.prisma.project.findUnique({
      where: {
        id: projectId,
      },
      include: {
        company: {
          include: {
            warehouseStores: {
              include: {
                warehouseStoreManagers: true,
              },
            },
          },
        },
      },
    });
    return approvers.company.warehouseStores.flatMap(
      (warehouseStore) => warehouseStore.warehouseStoreManagers,
    );
  }

  async approveMaterialReturn(
    materialReturnId: string,
    userId: string,
    status: ApprovalStatus,
  ): Promise<MaterialReturnVoucher> {
    const materialReturn = await this.prisma.materialReturnVoucher.findUnique({
      where: { id: materialReturnId },
      include: {
        items: {
          include: {
            productVariant: true,
          },
        },
      },
    });

    if (!materialReturn) {
      throw new NotFoundException('Material Return not found');
    }

    if (materialReturn.receivedById) {
      throw new NotFoundException('Already decided on this material return!');
    }

    if (status === ApprovalStatus.COMPLETED) {
      return await this.prisma.$transaction(async (prisma) => {
        for (const item of materialReturn.items) {
          const stock = await prisma.warehouseProduct.findUnique({
            where: {
              productVariantId_warehouseId_projectId: {
                productVariantId: item.productVariantId,
                warehouseId: materialReturn.receivingWarehouseStoreId,
                projectId: materialReturn.projectId,
              },
            },
          });

          if (!stock) {
            await prisma.warehouseProduct.create({
              data: {
                projectId: materialReturn.projectId,
                warehouseId: materialReturn.receivingWarehouseStoreId,
                productVariantId: item.productVariantId,
                quantity: item.quantity,
                currentPrice: item.unitCost,
              },
            });
          } else {
            const totalValueOfExistingStock =
              stock.currentPrice * stock.quantity;
            const totalValueOfNewStock = item.unitCost * item.quantity;
            const totalQuantityOfStock = stock.quantity + item.quantity;
            const newAveragePrice =
              (totalValueOfExistingStock + totalValueOfNewStock) /
              totalQuantityOfStock;

            await prisma.warehouseProduct.update({
              where: { id: stock.id },
              data: {
                quantity: totalQuantityOfStock,
                currentPrice: newAveragePrice,
              },
            });
          }
        }
        const updatedMaterialReturn =
          await prisma.materialReceiveVoucher.update({
            where: { id: materialReturnId },
            data: { status: status, approvedById: userId },
          });

        return updatedMaterialReturn;
      });
    } else {
      const updatedMaterialReturn =
        await this.prisma.materialReceiveVoucher.update({
          where: { id: materialReturnId },
          data: {
            approvedById: userId,
            status: status,
          },
        });
      return updatedMaterialReturn;
    }
  }

  async count(where?: Prisma.MaterialReturnVoucherWhereInput): Promise<number> {
    return this.prisma.materialReturnVoucher.count({ where });
  }

  async generatePdf(materialReturnId: string): Promise<string> {
    const materialReturn = await this.prisma.materialReturnVoucher.findUnique({
      where: { id: materialReturnId },
      include: {
        items: {
          include: {
            issueVoucher: true,
            productVariant: {
              include: {
                product: true,
              },
            },
          },
        },
        Project: true,
        receivedBy: true,
        returnedBy: true,
        receivingWarehouseStore: true,
      },
    });

    const browser = await puppeteer.launch({
      executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe',
      args: ['--headless'],
    });
    const page = await browser.newPage();
    const htmlContent = this.getHtmlContent(materialReturn);
    await page.setContent(htmlContent);
    const pdfBuffer = await page.pdf({
      path: 'hello.pdf',
      format: 'A4',
      printBackground: true,
      margin: {
        left: '0px',
        top: '0px',
        right: '0px',
        bottom: '0px',
      },
    });
    await browser.close();
    return pdfBuffer.toString('base64');
  }

  private getHtmlContent(materialReturn: MaterialReturnVoucher): string {
    return `
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Material Return Voucher</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #fff;}
          .voucher { padding: 20px; margin: auto; }
          .header { text-align: center; margin-bottom: 20px; }
          .header h1 { margin: 0; font-size: 24px; text-transform: uppercase; }
          .header h2 { margin: 0; font-size: 20px; text-transform: uppercase; }
          .header-details { display: flex; justify-content: space-between; margin-top: 10px; }
          .header-details div { display: flex; flex-direction: column; align-items: flex-start; }
          .header-details div label { font-weight: bold; }
          .header-details div span { margin-top: 5px; }
          .details-left { display: flex; flex-direction: column; gap: 10px; }
          .details-right { display: flex; flex-direction: column; gap: 10px; }
          .from-to { display: flex; justify-content: space-between; margin: 20px 0; }
          .from-to div { display: flex; flex-direction: column; }
          .from-to div label { font-weight: bold; }
          .from-to div span { margin-top: 5px; }
          table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
          table th, table td { border: 1px solid #000; padding: 6px; font-size: 12px; text-align: center; }
          .col-item-no { width: 6%; }
          .col-description { width: 30%; }
          .col-uom { width: 10%; }
          .col-quantity { width: 10%; }
          .col-cost { width: 10%; }
          .col-remark { width: 12%; }
          .approval { display: flex; justify-content: space-between; margin-bottom: 20px; }
          .approval-section { display: flex; flex-direction: column; align-items: flex-start; }
          .approval-section label { font-weight: bold; }
          .approval-section span { margin-top: 5px; }
          .footer { margin-top: 20px; display: flex; flex-direction: column; }
          .footer label { font-weight: bold; }
          .footer span { margin-top: 5px; }
      </style>
    </head>
    <body>
      <div
        style="
          display: flex;
          flex-direction: row;
          justify-content: center;
          margin-top: 40px;
        "
      >
        <div
          style="
            display: flex;
            width: 85%;
            justify-content: center;
            align-items: center;
          "
        >
          <div style="width: 100%" class="voucher">
            <div class="header">
              <h1>Lucid Real Estate</h1>
              <h2>Material Return Voucher</h2>
              <div class="header-details">
                <div class="details-left">
                  <div>
                    <label>Store Location:</label>
                    <span id="store-location">${materialReturn.receivingWarehouseStore ? materialReturn.receivingWarehouseStore.name : ''}</span>
                  </div>
                </div>

                <div class="details-right">
                  <div>
                    <label>Date:</label>
                    <span id="date">${format(materialReturn.createdAt, 'MMM dd, yyyy')}</span>
                  </div>
                  <div>
                    <label>Document No:</label>
                    <span id="reference-no">${materialReturn.serialNumber}</span>
                  </div>
                </div>
              </div>
            </div>
            <table>
              <thead>
                <tr>
                  <th class="col-item-no">Item No.</th>
                  <th class="col-description">Description</th>
                  <th class="col-uom">Issue Voucher No.</th>
                  <th class="col-uom">Unit of Measure</th>
                  <th class="col-quantity">Quantity Returned</th>
                  <th class="col-cost">Unit Cost</th>
                  <th class="col-cost">Total Cost</th>
                  <th class="col-remark">Remark</th>
                </tr>
              </thead>
              <tbody id="items">
                  ${materialReturn.items
                    .map(
                      (item, index) => `
                <tr>
                  <td class="col-item-no">${index + 1}</td>
                  <td class="col-description">${item.productVariant.variant} ${item.productVariant.product.name}</td>
                  <td class="col-uom">${item.issueVoucher.serialNumber}</td>
                  <td style="text-transform: lowercase;" class="col-uom">${item.productVariant.unitOfMeasure}</td>
                  <td class="col-quantity">${item.quantity}</td>
                  <td class="col-cost">${item.unitCost.toLocaleString()}</td>
                  <td class="col-cost">${item.totalCost.toLocaleString()}</td>
                   <td class="col-remark">${item.remark || ''}</td>
                </tr>
                `,
                    )
                    .join('')}
              </tbody>
            </table>
            <div class="approval">
              <div class="approval-section">
                <label>Prepared By:</label>
                <span id="requested-by">${materialReturn.returnedBy.fullName}</span>
              </div>
              <div class="approval-section">
                <label>Approved By:</label>
                <span id="approved-by">${materialReturn.receivedBy && materialReturn.receivedBy.fullName}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </body>
  </html>
    `;
  }
}
