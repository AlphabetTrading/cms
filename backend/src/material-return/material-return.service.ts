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
    const currentSerialNumber =
      (await this.prisma.materialReturnVoucher.count()) + 1;
    const serialNumber =
      'RTN/' + currentSerialNumber.toString().padStart(3, '0');

    const createdMaterialReturn =
      await this.prisma.materialReturnVoucher.create({
        data: {
          ...createMaterialReturn,
          serialNumber: serialNumber,
          items: {
            create: createMaterialReturn.items.map((item) => ({
              productId: item.productId,
              issueVoucherId: item.issueVoucherId,
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
        items: true,
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
      include: { items: true, receivedBy: true, returnedBy: true },
    });

    return materialReturn;
  }

  async updateMaterialReturn(
    materialReturnId: string,
    updateData: UpdateMaterialReturnInput,
  ): Promise<MaterialReturnVoucher> {
    const existingMaterialReturn =
      await this.prisma.materialReturnVoucher.findUnique({
        where: { id: materialReturnId },
      });

    if (!existingMaterialReturn) {
      throw new NotFoundException('Material Return not found');
    }

    const itemUpdateConditions = updateData.items.map((item) => ({
      productId: item.productId,
    }));

    const updatedMaterialReturn =
      await this.prisma.materialReturnVoucher.update({
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
          items: true,
        },
      });

    return updatedMaterialReturn;
  }

  async deleteMaterialReturn(materialReturnId: string): Promise<void> {
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
  }

  async approveMaterialReturn(
    materialReturnId: string,
    userId: string,
    status: ApprovalStatus,
  ) {
    const materialReturn =
      await this.prisma.materialReturnVoucher.findUnique({
        where: { id: materialReturnId },
      });

    if (!materialReturn) {
      throw new NotFoundException('Material Return not found');
    }

    if (materialReturn.receivedById) {
      throw new NotFoundException('Already decided on this material return!');
    }

    const updatedMaterialReturn = await this.prisma.materialReturnVoucher.update({
      where: { id: materialReturnId },
      data: {
        receivedById: userId,
        status: status,
      },
    });
  
    return updatedMaterialReturn;
  }

  async count(where?: Prisma.MaterialReturnVoucherWhereInput): Promise<number> {
    return this.prisma.materialReturnVoucher.count({ where });
  }
}
