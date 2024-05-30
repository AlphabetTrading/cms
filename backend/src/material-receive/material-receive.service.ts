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
    const currentSerialNumber =
      (await this.prisma.materialReceiveVoucher.count()) + 1;
    const serialNumber =
      'REC/' + currentSerialNumber.toString().padStart(3, '0');

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

      const updatedMaterialReceive =
        await prisma.materialReceiveVoucher.update({
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
        });

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

  async approveMaterialReceive(
    materialReceiveId: string,
    userId: string,
    status: ApprovalStatus,
  ) {
    const materialReceive = await this.prisma.materialReceiveVoucher.findUnique(
      {
        where: { id: materialReceiveId },
      },
    );

    if (!materialReceive) {
      throw new NotFoundException('Material Receive not found');
    }

    if (materialReceive.approvedById) {
      throw new NotFoundException('Already decided on this material receive!');
    }

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

  async count(
    where?: Prisma.MaterialReceiveVoucherWhereInput,
  ): Promise<number> {
    return this.prisma.materialReceiveVoucher.count({ where });
  }
}
