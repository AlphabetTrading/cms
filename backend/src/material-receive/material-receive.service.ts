import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialReceiveInput } from './dto/create-material-receive.input';
import { UpdateMaterialReceiveInput } from './dto/update-material-receive.input';
import { MaterialReceiveVoucher } from './model/material-receive.model';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';
import { DocumentType } from 'src/common/enums/document-type';

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
        ProjectManager: true,
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
}
