import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialReturnInput } from './dto/create-material-return.input';
import { MaterialReturnVoucher } from './model/material-return.model';
import { UpdateMaterialReturnInput } from './dto/update-material-return.input';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';
import { DocumentType } from 'src/common/enums/document-type';

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

  async getMaterialReturnApprovers() {
    const approvers = await this.prisma.warehouseStoreManager.findMany({
      select: {
        StoreManager: true,
      },
    });
    return approvers;
  }

  async approveMaterialReturn(
    materialReturnId: string,
    userId: string,
    status: ApprovalStatus,
  ) {
    const materialReturn = await this.prisma.materialReturnVoucher.findUnique({
      where: { id: materialReturnId },
      include: {
        items: true,
      },
    });

    if (!materialReturn) {
      throw new NotFoundException('Material Return not found');
    }

    if (materialReturn.receivedById) {
      throw new NotFoundException('Already decided on this material return!');
    }

    if (status === ApprovalStatus.COMPLETED) {
      await this.prisma.$transaction(async (prisma) => {
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
}
