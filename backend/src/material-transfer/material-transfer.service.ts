import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialTransferInput } from './dto/create-material-transfer.input';
import { UpdateMaterialTransferInput } from './dto/update-material-transfer.input';
import { MaterialTransferVoucher } from './model/material-transfer.model';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DocumentType } from 'src/common/enums/document-type';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';
import * as pdf from 'html-pdf';
import { format } from 'date-fns';

@Injectable()
export class MaterialTransferService {
  constructor(private prisma: PrismaService) {}

  async createMaterialTransfer(
    createMaterialTransferInput: CreateMaterialTransferInput,
  ): Promise<MaterialTransferVoucher> {
    const lastMaterialTransferVoucher =
      await this.prisma.materialTransferVoucher.findFirst({
        select: {
          serialNumber: true,
        },
        orderBy: {
          serialNumber: 'desc',
        },
      });
    let currentSerialNumber = 1;
    if (lastMaterialTransferVoucher) {
      currentSerialNumber =
        parseInt(lastMaterialTransferVoucher.serialNumber.split('/')[1]) + 1;
    }
    const serialNumber =
      'TN/' + currentSerialNumber.toString().padStart(4, '0');

    const createdMaterialTransfer =
      await this.prisma.materialTransferVoucher.create({
        data: {
          ...createMaterialTransferInput,
          serialNumber: serialNumber,
          items: {
            create: createMaterialTransferInput.items.map((item) => ({
              productVariantId: item.productVariantId,
              quantityRequested: item.quantityRequested,
              quantityTransferred: item.quantityTransferred,
              unitCost: item.unitCost,
              totalCost: item.totalCost,
              remark: item.remark,
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
          materialReceive: true,
          receivingWarehouseStore: true,
          sendingWarehouseStore: true,
          Project: true,
          approvedBy: true,
          preparedBy: true,
        },
      });
    return createdMaterialTransfer;
  }

  async getMaterialTransfers({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.MaterialTransferVoucherWhereInput;
    orderBy?: Prisma.MaterialTransferVoucherOrderByWithRelationInput;
  }): Promise<MaterialTransferVoucher[]> {
    const materialTransfers =
      await this.prisma.materialTransferVoucher.findMany({
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
          materialReceive: true,
          receivingWarehouseStore: true,
          sendingWarehouseStore: true,
          Project: true,
          approvedBy: true,
          preparedBy: true,
        },
      });
    return materialTransfers;
  }

  async getMaterialTransfersCountByStatus({
    where,
  }: {
    where?: Prisma.MaterialTransferVoucherWhereInput;
  }): Promise<any> {
    const statusCounts = await this.prisma.materialTransferVoucher.groupBy({
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
    documentTransaction.type = DocumentType.MATERIAL_TRANSFER;

    return documentTransaction;
  }
  async getMaterialTransferById(
    materialTransferId: string,
  ): Promise<MaterialTransferVoucher | null> {
    const materialTransfer =
      await this.prisma.materialTransferVoucher.findUnique({
        where: { id: materialTransferId },
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
          materialReceive: true,
          receivingWarehouseStore: true,
          sendingWarehouseStore: true,
          Project: true,
          approvedBy: true,
          preparedBy: true,
        },
      });

    return materialTransfer;
  }

  async updateMaterialTransfer(
    input: UpdateMaterialTransferInput,
  ): Promise<MaterialTransferVoucher> {
    const { id: materialTransferId, ...updateData } = input;

    return await this.prisma.$transaction(async (prisma) => {
      const existingMaterialTransfer =
        await prisma.materialTransferVoucher.findUnique({
          where: { id: materialTransferId },
        });

      if (!existingMaterialTransfer) {
        throw new NotFoundException('Material Transfer not found');
      }

      const itemUpdateConditions = updateData.items.map((item) => ({
        productVariantId: item.productVariantId,
      }));

      const updatedMaterialTransfer =
        await prisma.materialTransferVoucher.update({
          where: { id: materialTransferId },
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
            materialReceive: true,
            receivingWarehouseStore: true,
            sendingWarehouseStore: true,
            Project: true,
            approvedBy: true,
            preparedBy: true,
          },
        });

      return updatedMaterialTransfer;
    });
  }

  async deleteMaterialTransfer(
    materialTransferId: string,
  ): Promise<MaterialTransferVoucher> {
    const existingMaterialTransfer =
      await this.prisma.materialTransferVoucher.findUnique({
        where: { id: materialTransferId },
      });

    if (!existingMaterialTransfer) {
      throw new NotFoundException('Material Transfer not found');
    }

    await this.prisma.materialTransferVoucher.delete({
      where: { id: materialTransferId },
    });

    return existingMaterialTransfer;
  }

  async approveMaterialTransfer(
    materialTransferId: string,
    userId: string,
    status: ApprovalStatus,
  ): Promise<MaterialTransferVoucher> {
    const materialTransfer =
      await this.prisma.materialTransferVoucher.findUnique({
        where: { id: materialTransferId },
        include: {
          items: {
            include: {
              productVariant: true,
            },
          },
        },
      });

    if (!materialTransfer) {
      throw new NotFoundException('Material Transfer not found');
    }

    if (materialTransfer.approvedById) {
      throw new NotFoundException('Already decided on this material transfer!');
    }

    if (status === ApprovalStatus.COMPLETED) {
      return await this.prisma.$transaction(async (prisma) => {
        for (const item of materialTransfer.items) {
          const outgoingStock = await prisma.warehouseProduct.findUnique({
            where: {
              productVariantId_warehouseId_projectId: {
                productVariantId: item.productVariantId,
                warehouseId: materialTransfer.sendingWarehouseStoreId,
                projectId: materialTransfer.projectId,
              },
            },
          });

          if (
            !outgoingStock ||
            outgoingStock.quantity < item.quantityRequested
          ) {
            throw new ConflictException(
              `Not enough stock available for ${item.productVariant.variant}`,
            );
          }
          await prisma.warehouseProduct.update({
            where: {
              id: outgoingStock.id,
              version: outgoingStock.version,
            },
            data: {
              quantity: outgoingStock.quantity - item.quantityTransferred,
              version: outgoingStock.version + 1,
            },
          });

          const incomingStock = await prisma.warehouseProduct.findUnique({
            where: {
              productVariantId_warehouseId_projectId: {
                productVariantId: item.productVariantId,
                warehouseId: materialTransfer.receivingWarehouseStoreId,
                projectId: materialTransfer.projectId,
              },
            },
          });

          if (!incomingStock) {
            await prisma.warehouseProduct.create({
              data: {
                projectId: materialTransfer.projectId,
                warehouseId: materialTransfer.receivingWarehouseStoreId,
                productVariantId: item.productVariantId,
                quantity: item.quantityTransferred,
                currentPrice: item.unitCost,
              },
            });
          } else {
            const totalValueOfExistingStock =
              incomingStock.currentPrice * incomingStock.quantity;
            const totalValueOfNewStock =
              item.unitCost * item.quantityTransferred;
            const totalQuantityOfStock =
              incomingStock.quantity + item.quantityTransferred;
            const newAveragePrice =
              (totalValueOfExistingStock + totalValueOfNewStock) /
              totalQuantityOfStock;

            await prisma.warehouseProduct.update({
              where: { id: incomingStock.id },
              data: {
                quantity: totalQuantityOfStock,
                currentPrice: newAveragePrice,
              },
            });
          }
        }

        const updatedMaterialTransfer =
          await prisma.materialTransferVoucher.update({
            where: { id: materialTransferId },
            data: { status: status, approvedById: userId },
          });

        return updatedMaterialTransfer;
      });
    } else {
      const updatedMaterialTransfer =
        await this.prisma.materialReceiveVoucher.update({
          where: { id: materialTransferId },
          data: {
            approvedById: userId,
            status: status,
          },
        });
      return updatedMaterialTransfer;
    }
  }

  async count(
    where?: Prisma.MaterialTransferVoucherWhereInput,
  ): Promise<number> {
    return this.prisma.materialTransferVoucher.count({ where });
  }

  async generatePdf(materialTransferId: string): Promise<string> {
    const materialTransfer =
      await this.prisma.materialTransferVoucher.findUnique({
        where: { id: materialTransferId },
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
          materialReceive: true,
          receivingWarehouseStore: true,
          sendingWarehouseStore: true,
          Project: true,
          approvedBy: true,
          preparedBy: true,
        },
      });

    const htmlContent = this.getHtmlContent(materialTransfer);
    return new Promise<string>((resolve, reject) => {
      pdf.create(htmlContent).toBuffer((err, buffer) => {
        if (err) {
          reject(err);
        } else {
          resolve(buffer.toString('base64'));
        }
      });
    });
  }

  private getHtmlContent(materialTransfer: MaterialTransferVoucher): string {
    return `
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Material Transfer Voucher</title>
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
            width: 90%;
            justify-content: center;
            align-items: center;
          "
        >
          <div style="width: 100%" class="voucher">
            <div class="header">
              <h1>Lucid Real Estate</h1>
              <h2>Material Transfer Voucher</h2>
              <br/>
              <div class="header-details">
                <div class="details-right">
                  <div>
                    <label>Date:</label>
                    <span id="date">${format(materialTransfer.createdAt, 'MMM dd, yyyy')}</span>
                  </div>
                  <div>
                    <label>Document No:</label>
                    <span>${materialTransfer.serialNumber}</span>
                  </div>
                </div>
              </div>
              <div class="header-details">
                <div class="details-left">
                  <div>
                    <label>Sending Store:</label>
                    <span id="store-name">${materialTransfer.sendingWarehouseStore.name}</span>
                  </div>
                  <div>
                    <label>Receiving Store:</label>
                    <span id="store-name">${materialTransfer.receivingWarehouseStore.name}</span>
                  </div>
                  <div>
                    <label>Requisition No:</label>
                    <span id="store-location">${materialTransfer.requisitionNumber || ''}</span>
                  </div>
                </div>
                <div class="details-right">
                  <div>
                    <label>Material Group:</label>
                    <span id="reference-no">${materialTransfer.materialGroup || ''}</span>
                  </div>
                  <div>
                    <label>Vehicle Plate No:</label>
                    <span id="reference-no">${materialTransfer.vehiclePlateNo || ''}</span>
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
                  <th class="col-quantity">Quantity Requested</th>
                  <th class="col-quantity">Quantity Transferred</th>
                  <th colspan="2" class="col-cost">Unit Cost</th>
                  <th colspan="2" class="col-cost">Total Cost</th>
                  <th class="col-remark">Remark</th>
                </tr>
              </thead>
              <tbody id="items">
                  ${materialTransfer.items
                    .map(
                      (item, index) => `
                <tr>
                  <td class="col-item-no">${index + 1}</td>
                  <td class="col-description">${item.productVariant.variant} ${item.productVariant.product.name}</td>
                  <td style="text-transform: lowercase;" class="col-uom">${item.productVariant.unitOfMeasure}</td>
                  <td class="col-quantity">${item.quantityRequested}</td>
                  <td class="col-quantity">${item.quantityTransferred}</td>
                 <td class="col-cost-money">${item.unitCost.toLocaleString().split('.')[0]}</td>
                  <td class="col-cost-cent">${(item.unitCost.toString().split('.')[1] || '00').padEnd(2, '0')}</td>
                  <td class="col-cost-money">${item.totalCost.toLocaleString().split('.')[0]}</td>
                  <td class="col-cost-cent">${(item.totalCost.toString().split('.')[1] || '00').padEnd(2, '0')}</td>
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
                <span id="requested-by">${materialTransfer.preparedBy.fullName}</span>
              </div>
              <div class="approval-section">
                <label>Approved By:</label>
                <span id="approved-by">${materialTransfer.approvedBy && materialTransfer.approvedBy.fullName}</span>
              </div>
              <div class="approval-section">
                <label>Sent Through:</label>
                <span id="approved-by">${materialTransfer.sentThroughName || ''}</span>
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
