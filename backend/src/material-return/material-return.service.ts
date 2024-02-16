import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialReturnInput } from './dto/create-material-return.input';
import { MaterialReturnVoucher } from './model/material-return.model';
import { UpdateMaterialReturnInput } from './dto/update-material-return.input';

@Injectable()
export class MaterialReturnService {
  constructor(private prisma: PrismaService) {}

  async createMaterialReturn(
    createMaterialReturn: CreateMaterialReturnInput,
  ): Promise<MaterialReturnVoucher> {
    const createdMaterialReturn =
      await this.prisma.materialReturnVoucher.create({
        data: {
          date: createMaterialReturn.date,
          from: createMaterialReturn.from,
          receivingStore: createMaterialReturn.receivingStore,
          receivedById: createMaterialReturn.receivedById,
          returnedById: createMaterialReturn.returnedById,
          items: {
            create: createMaterialReturn.items.map((item) => ({
              listNo: item.listNo,
              description: item.description,
              unitOfMeasure: item.unitOfMeasure,
              issueVoucherId: item.issueVoucherId,
              quantityReturned: item.quantityReturned,
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

  async getMaterialReturns(): Promise<MaterialReturnVoucher[]> {
    const materialReturns = await this.prisma.materialReturnVoucher.findMany({
      include: {
        items: true,
      },
    });
    return materialReturns;
  }

  async getMaterialReturnById(
    materialReturnId: string,
  ): Promise<MaterialReturnVoucher | null> {
    const materialReturn = await this.prisma.materialReturnVoucher.findUnique({
      where: { id: materialReturnId },
      include: { items: true },
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
      listNo: item.listNo,
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
}
