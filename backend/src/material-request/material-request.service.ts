import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialRequestInput } from './dto/create-material-request.input';
import { MaterialRequestVoucher } from './model/material-request.model';
import { UpdateMaterialRequestInput } from './dto/update-material-request.input';
import { Prisma } from '@prisma/client';

@Injectable()
export class MaterialRequestService {
  constructor(private prisma: PrismaService) {}

  async createMaterialRequest(
    createMaterialRequest: CreateMaterialRequestInput,
  ): Promise<MaterialRequestVoucher> {
    const currentSerialNumber =
      await this.prisma.materialRequestVoucher.count();
    const serialNumber =
      'MRQ/' + currentSerialNumber.toString().padStart(3, '0');

    const createdMaterialRequest =
      await this.prisma.materialRequestVoucher.create({
        data: {
          ...createMaterialRequest,
          serialNumber: serialNumber,
          items: {
            create: createMaterialRequest.items.map((item) => ({
              listNo: item.listNo,
              description: item.description,
              unitOfMeasure: item.unitOfMeasure,
              quantity: item.quantity,
              inStockQuantity: item.inStockQuantity,
              toBePurchasedQuantity: item.toBePurchasedQuantity,
              remark: item.remark,
            })),
          },
        },
        include: {
          items: true,
        },
      });
    return createdMaterialRequest;
  }

  async getMaterialRequests({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.MaterialRequestVoucherWhereInput;
    orderBy?: Prisma.MaterialRequestVoucherOrderByWithRelationInput;
  }): Promise<MaterialRequestVoucher[]> {
    const materialRequests = await this.prisma.materialRequestVoucher.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        items: true,
      },
    });
    return materialRequests;
  }

  async getMaterialRequestById(
    materialRequestId: string,
  ): Promise<MaterialRequestVoucher | null> {
    const materialRequest = await this.prisma.materialRequestVoucher.findUnique(
      {
        where: { id: materialRequestId },
        include: { items: true },
      },
    );

    return materialRequest;
  }

  async updateMaterialRequest(
    materialRequestId: string,
    updateData: UpdateMaterialRequestInput,
  ): Promise<MaterialRequestVoucher> {
    const existingMaterialRequest =
      await this.prisma.materialRequestVoucher.findUnique({
        where: { id: materialRequestId },
      });

    if (!existingMaterialRequest) {
      throw new NotFoundException('Material Request not found');
    }

    const itemUpdateConditions = updateData.items.map((item) => ({
      listNo: item.listNo,
    }));

    const updatedMaterialRequest =
      await this.prisma.materialRequestVoucher.update({
        where: { id: materialRequestId },
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

    return updatedMaterialRequest;
  }

  async deleteMaterialRequest(materialRequestId: string): Promise<void> {
    const existingMaterialRequest =
      await this.prisma.materialRequestVoucher.findUnique({
        where: { id: materialRequestId },
      });

    if (!existingMaterialRequest) {
      throw new NotFoundException('Material Request not found');
    }

    await this.prisma.materialRequestVoucher.delete({
      where: { id: materialRequestId },
    });
  }

  async count(
    where?: Prisma.MaterialRequestVoucherWhereInput,
  ): Promise<number> {
    return this.prisma.materialRequestVoucher.count({ where });
  }
}