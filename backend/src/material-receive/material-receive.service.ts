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
              productId: item.productId,
              quantity: item.quantity,
              unitCost: item.unitCost,
              totalCost: item.totalCost,
            })),
          },
        },
        include: {
          items: true,
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
        items: true,
        approvedBy: true,
        purchasedBy: true,
        materialRequest: true,
        purchaseOrder: true,
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
          items: true,
          approvedBy: true,
          purchasedBy: true,
          materialRequest: true,
          purchaseOrder: true,
        },
      },
    );

    return materialReceive;
  }

  async updateMaterialReceive(
    materialReceiveId: string,
    updateData: UpdateMaterialReceiveInput,
  ): Promise<MaterialReceiveVoucher> {
    const existingMaterialReceive =
      await this.prisma.materialReceiveVoucher.findUnique({
        where: { id: materialReceiveId },
      });

    if (!existingMaterialReceive) {
      throw new NotFoundException('Material Receive not found');
    }

    const itemUpdateConditions = updateData.items.map((item) => ({
      productId: item.productId,
    }));

    const updatedMaterialReceive =
      await this.prisma.materialReceiveVoucher.update({
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
          items: true,
        },
      });

    return updatedMaterialReceive;
  }

  async deleteMaterialReceive(materialReceiveId: string): Promise<void> {
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
  }

  async approveMaterialReceive(
    materialReceiveId: string,
    userId: string,
    status: ApprovalStatus,
  ) {
    const materialReceive = await this.prisma.materialReceiveVoucher.findUnique(
      {
        where: { id: materialReceiveId }
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
