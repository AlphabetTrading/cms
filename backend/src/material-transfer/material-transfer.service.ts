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
          createdAt: 'desc',
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
  ) {
    const materialTransfer =
      await this.prisma.materialTransferVoucher.findUnique({
        where: { id: materialTransferId },
        include: {
          items: true,
        },
      });

    if (!materialTransfer) {
      throw new NotFoundException('Material Transfer not found');
    }

    if (materialTransfer.approvedById) {
      throw new NotFoundException('Already decided on this material transfer!');
    }

    if (status === ApprovalStatus.COMPLETED) {
      await this.prisma.$transaction(async (prisma) => {
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
              `Not enough stock available for product variant ID ${item.productVariantId}`,
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
}