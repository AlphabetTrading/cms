import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialReceiveInput } from './dto/create-material-receive.input';
import { UpdateMaterialReceiveInput } from './dto/update-material-receive.input';
import { MaterialReceiveVoucher } from './model/material-receive.model';
import { ApprovalStatus, Prisma, UserRole } from '@prisma/client';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';
import { DocumentType } from 'src/common/enums/document-type';
import puppeteer from 'puppeteer-core';
import { format } from 'date-fns';

@Injectable()
export class MaterialReceiveService {
  constructor(private prisma: PrismaService) {}

  async createMaterialReceive(
    createMaterialReceive: CreateMaterialReceiveInput,
  ): Promise<MaterialReceiveVoucher> {
    const lastMaterialReceiveVoucher =
      await this.prisma.materialReceiveVoucher.findFirst({
        select: {
          serialNumber: true,
        },
        orderBy: {
          createdAt: 'desc',
        },
      });
    let currentSerialNumber = 1;
    if (lastMaterialReceiveVoucher) {
      currentSerialNumber =
        parseInt(lastMaterialReceiveVoucher.serialNumber.split('/')[1]) + 1;
    }
    const serialNumber =
      'REC/' + currentSerialNumber.toString().padStart(4, '0');

    const createdMaterialReceive =
      await this.prisma.materialReceiveVoucher.create({
        data: {
          ...createMaterialReceive,
          serialNumber: serialNumber,
          items: {
            create: createMaterialReceive.items.map((item) => ({
              productVariantId: item.productVariantId,
              quantity: item.quantity,
              unitCost: item.unitCost,
              totalCost: item.totalCost,
              loadingCost: item.loadingCost,
              unloadingCost: item.unloadingCost,
              transportationCost: item.transportationCost,
            })),
          },
        },
        include: {
          items: {
            include: {
              productVariant: {
                include: {
                  product: true,
                },
              },
            },
          },
          Project: true,
          materialRequest: true,
          approvedBy: true,
          purchasedBy: true,
          purchaseOrder: true,
          WarehouseStore: true,
        },
      });

    return createdMaterialReceive;
  }

  async getMaterialReceives({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.MaterialReceiveVoucherWhereInput;
    orderBy?: Prisma.MaterialReceiveVoucherOrderByWithRelationInput;
  }): Promise<MaterialReceiveVoucher[]> {
    const materialReceives = await this.prisma.materialReceiveVoucher.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        items: {
          include: {
            productVariant: {
              include: {
                product: true,
              },
            },
          },
        },
        Project: true,
        materialRequest: true,
        approvedBy: true,
        purchasedBy: true,
        purchaseOrder: true,
        WarehouseStore: true,
      },
    });
    return materialReceives;
  }

  async getMaterialReceiveCountByStatus({
    where,
  }: {
    where?: Prisma.MaterialReceiveVoucherWhereInput;
  }): Promise<any> {
    const statusCounts = await this.prisma.materialReceiveVoucher.groupBy({
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
    documentTransaction.type = DocumentType.MATERIAL_RECEIVING;

    return documentTransaction;
  }

  async getMaterialReceiveById(
    materialReceiveId: string,
  ): Promise<MaterialReceiveVoucher | null> {
    const materialReceive = await this.prisma.materialReceiveVoucher.findUnique(
      {
        where: { id: materialReceiveId },
        include: {
          items: {
            include: {
              productVariant: {
                include: {
                  product: true,
                },
              },
            },
          },
          Project: true,
          materialRequest: true,
          approvedBy: true,
          purchasedBy: true,
          purchaseOrder: true,
          WarehouseStore: true,
        },
      },
    );

    return materialReceive;
  }

  async updateMaterialReceive(
    input: UpdateMaterialReceiveInput,
  ): Promise<MaterialReceiveVoucher> {
    const { id: materialReceiveId, ...updateData } = input;

    return await this.prisma.$transaction(async (prisma) => {
      const existingMaterialReceive =
        await prisma.materialReceiveVoucher.findUnique({
          where: { id: materialReceiveId },
        });

      if (!existingMaterialReceive) {
        throw new NotFoundException('Material Receive not found');
      }

      const itemUpdateConditions = updateData.items.map((item) => ({
        productVariantId: item.productVariantId,
      }));

      const updatedMaterialReceive = await prisma.materialReceiveVoucher.update(
        {
          where: { id: materialReceiveId },
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
                productVariant: {
                  include: {
                    product: true,
                  },
                },
              },
            },
            Project: true,
            materialRequest: true,
            approvedBy: true,
            purchasedBy: true,
            purchaseOrder: true,
            WarehouseStore: true,
          },
        },
      );

      return updatedMaterialReceive;
    });
  }

  async deleteMaterialReceive(
    materialReceiveId: string,
  ): Promise<MaterialReceiveVoucher> {
    const existingMaterialReceive =
      await this.prisma.materialReceiveVoucher.findUnique({
        where: { id: materialReceiveId },
      });

    if (!existingMaterialReceive) {
      throw new NotFoundException('Material Receive not found');
    }

    await this.prisma.materialReceiveVoucher.delete({
      where: { id: materialReceiveId },
    });

    return existingMaterialReceive;
  }

  async getMaterialReceiveApprovers(projectId?: string) {
    const approvers = await this.prisma.project.findMany({
      where: {
        id: projectId,
      },
      select: {
        ProjectUsers: {
          where: {
            user: {
              role: UserRole.PROJECT_MANAGER,
            },
          },
          select: {
            userId: true,
          },
        },
      },
  });
    return approvers;
  }

  async approveMaterialReceive(
    materialReceiveId: string,
    userId: string,
    status: ApprovalStatus,
  ): Promise<MaterialReceiveVoucher> {
    const materialReceive = await this.prisma.materialReceiveVoucher.findUnique(
      {
        where: { id: materialReceiveId },
        include: {
          items: {
            include: {
              productVariant: true,
            },
          },
        },
      },
    );

    if (!materialReceive) {
      throw new NotFoundException('Material Receive not found');
    }

    if (materialReceive.approvedById) {
      throw new NotFoundException('Already decided on this material receive!');
    }

    if (status === ApprovalStatus.COMPLETED) {
      return await this.prisma.$transaction(async (prisma) => {
        for (const item of materialReceive.items) {
          const stock = await prisma.warehouseProduct.findUnique({
            where: {
              productVariantId_warehouseId_projectId: {
                productVariantId: item.productVariantId,
                warehouseId: materialReceive.warehouseStoreId,
                projectId: materialReceive.projectId,
              },
            },
          });

          if (!stock) {
            await prisma.warehouseProduct.create({
              data: {
                projectId: materialReceive.projectId,
                warehouseId: materialReceive.warehouseStoreId,
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
        const updatedMaterialReceive =
          await prisma.materialReceiveVoucher.update({
            where: { id: materialReceiveId },
            data: { status: status, approvedById: userId },
          });

        return updatedMaterialReceive;
      });
    } else {
      const updatedMaterialReceive =
        await this.prisma.materialReceiveVoucher.update({
          where: { id: materialReceiveId },
          data: {
            approvedById: userId,
            status: status,
          },
        });
      return updatedMaterialReceive;
    }
  }

  async count(
    where?: Prisma.MaterialReceiveVoucherWhereInput,
  ): Promise<number> {
    return this.prisma.materialReceiveVoucher.count({ where });
  }

  async generatePdf(materialReceiveId: string): Promise<string> {
    const materialReceive = await this.prisma.materialReceiveVoucher.findUnique(
      {
        where: { id: materialReceiveId },
        include: {
          items: {
            include: {
              productVariant: {
                include: {
                  product: true,
                },
              },
            },
          },
          Project: true,
          materialRequest: true,
          approvedBy: true,
          purchasedBy: true,
          purchaseOrder: true,
          WarehouseStore: true,
        },
      },
    );

    const browser = await puppeteer.launch({
      executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe',
      args: ['--headless'],
    });
    const page = await browser.newPage();
    const htmlContent = this.getHtmlContent(materialReceive);
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

  private getHtmlContent(materialReceive: MaterialReceiveVoucher): string {
    return `
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Material Receive Voucher</title>
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
          .col-cost { width: 15%; }
          .col-cost-money{ width: 10%; }
          .col-cost-cent{ width: 5%; }
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
              <h2>Material Receive Voucher</h2>
              <div class="header-details">
                <div class="details-left">
                  <div>
                    <label>Date:</label>
                    <span id="date">${format(materialReceive.createdAt, 'MMM dd, yyyy')}</span>
                  </div>
                  <div>
                    <label>Project:</label>
                    <span>${materialReceive.Project.name}</span>
                  </div>
                  <div>
                    <label>Supplier Name:</label>
                    <span>${materialReceive.supplierName || ''}</span>
                  </div>
                  <div>
                    <label>Material Req. No:</label>
                    <span>${materialReceive.materialRequest.serialNumber || ''}</span>
                  </div>
                </div>
                <div class="details-right">
                  <div>
                    <label>Document No:</label>
                    <span id="reference-no">${materialReceive.serialNumber}</span>
                  </div>
                  <div>
                    <label>Invoice No:</label>
                    <span id="reference-no">${materialReceive.invoiceId || ''}</span>
                  </div>

                  <div>
                    <label>Purchase Req. No:</label>
                    <span id="store-name">${materialReceive.purchaseOrder.serialNumber || ''}</span>
                  </div>
                </div>
              </div>
            </div>
            <table>
              <thead>
                <tr>
                  <th class="col-item-no">Item No.</th>
                  <th class="col-description">Description</th>
                  <th class="col-uom">Unit of Measure</th>
                  <th class="col-quantity">Quantity</th>
                  <th colspan="2" class="col-cost">Unit Cost</th>
                  <th colspan="2" class="col-cost">Total Cost</th>
                </tr>
              </thead>
              <tbody id="items">
                  ${materialReceive.items
                    .map(
                      (item, index) => `
                <tr>
                  <td class="col-item-no">${index + 1}</td>
                  <td class="col-description">${item.productVariant.variant} ${item.productVariant.product.name}</td>
                  <td style="text-transform: lowercase;" class="col-uom">${item.productVariant.unitOfMeasure}</td>
                  <td class="col-quantity">${item.quantity}</td>
                  <td class="col-cost-money">${item.unitCost.toLocaleString().split('.')[0]}</td>
                  <td class="col-cost-cent">${(item.unitCost.toString().split('.')[1] || '00').padEnd(2, '0')}</td>
                  <td class="col-cost-money">${item.totalCost.toLocaleString().split('.')[0]}</td>
                  <td class="col-cost-cent">${(item.totalCost.toString().split('.')[1] || '00').padEnd(2, '0')}</td>
                </tr>
                `,
                    )
                    .join('')}
              </tbody>
            </table>
            <div class="approval">
              <div class="approval-section">
                <label>Prepared By:</label>
                <span id="requested-by">${materialReceive.purchasedBy.fullName}</span>
              </div>
              <div class="approval-section">
                <label>Approved By:</label>
                <span id="approved-by">${materialReceive.approvedBy && materialReceive.approvedBy.fullName}</span>
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
