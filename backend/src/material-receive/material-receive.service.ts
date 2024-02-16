import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialReceiveInput } from './dto/create-material-receive.input';
import { UpdateMaterialReceiveInput } from './dto/update-material-receive.input';
import { MaterialReceiveVoucher } from './model/material-receive.model';

@Injectable()
export class MaterialReceiveService {
  constructor(private prisma: PrismaService) {}

  async createMaterialReceive(
    createMaterialReceive: CreateMaterialReceiveInput,
  ): Promise<MaterialReceiveVoucher> {
    const createdMaterialReceive =
      await this.prisma.materialReceiveVoucher.create({
        data: {
          date: createMaterialReceive.date,
          projectDetails: createMaterialReceive.projectDetails,
          supplierName: createMaterialReceive.supplierName,
          invoiceId: createMaterialReceive.invoiceId,
          materialRequestId: createMaterialReceive.materialRequestId,
          purchaseOrderId: createMaterialReceive.purchaseOrderId,
          purchasedById: createMaterialReceive.purchasedById,
          receivedById: createMaterialReceive.receivedById,
          approvedById: createMaterialReceive.approvedById,
          items: {
            create: createMaterialReceive.items.map((item) => ({
              listNo: item.listNo,
              description: item.description,
              unitOfMeasure: item.unitOfMeasure,
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

  async getMaterialReceives(): Promise<MaterialReceiveVoucher[]> {
    const materialReceives = await this.prisma.materialReceiveVoucher.findMany({
      include: {
        items: true,
      },
    });
    return materialReceives;
  }

  async getMaterialReceiveById(
    materialReceiveId: string,
  ): Promise<MaterialReceiveVoucher | null> {
    const materialReceive = await this.prisma.materialReceiveVoucher.findUnique(
      {
        where: { id: materialReceiveId },
        include: { items: true },
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
      listNo: item.listNo,
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
}
