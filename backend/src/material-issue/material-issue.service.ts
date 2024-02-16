import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialIssueInput } from './dto/create-material-issue.input';
import { UpdateMaterialIssueInput } from './dto/update-material-issue.input';
import { MaterialIssueVoucher } from './model/material-issue.model';
import { Prisma } from '@prisma/client';

@Injectable()
export class MaterialIssueService {
  constructor(private prisma: PrismaService) {}

  async createMaterialIssue(
    createMaterialIssueInput: CreateMaterialIssueInput,
  ): Promise<MaterialIssueVoucher> {
    const currentSerialNumber = await this.prisma.materialIssueVoucher.count();
    const serialNumber =
      'ISS/' + currentSerialNumber.toString().padStart(3, '0');

    const createdMaterialIssue = await this.prisma.materialIssueVoucher.create({
      data: {
        ...createMaterialIssueInput,
        serialNumber: serialNumber,
        items: {
          create: createMaterialIssueInput.items.map((item) => ({
            listNo: item.listNo,
            description: item.description,
            unitOfMeasure: item.unitOfMeasure,
            quantity: item.quantity,
            unitCost: item.unitCost,
            totalCost: item.totalCost,
            remark: item.remark,
          })),
        },
      },
      include: {
        items: true,
      },
    });
    return createdMaterialIssue;
  }

  async getMaterialIssues({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.MaterialIssueVoucherWhereInput;
    orderBy?: Prisma.MaterialIssueVoucherOrderByWithRelationInput;
  }): Promise<MaterialIssueVoucher[]> {
    const materialIssues = await this.prisma.materialIssueVoucher.findMany({
      skip,
      take,
      where,
      orderBy,
      include: { items: true },
    });
    return materialIssues;
  }

  async getMaterialIssueById(
    materialIssueId: string,
  ): Promise<MaterialIssueVoucher | null> {
    const materialIssue = await this.prisma.materialIssueVoucher.findUnique({
      where: { id: materialIssueId },
      include: { items: true },
    });

    return materialIssue;
  }

  async updateMaterialIssue(
    materialIssueId: string,
    updateData: UpdateMaterialIssueInput,
  ): Promise<MaterialIssueVoucher> {
    const existingMaterialIssue =
      await this.prisma.materialIssueVoucher.findUnique({
        where: { id: materialIssueId },
      });

    if (!existingMaterialIssue) {
      throw new NotFoundException('Material Issue not found');
    }

    const itemUpdateConditions = updateData.items.map((item) => ({
      listNo: item.listNo,
    }));

    const updatedMaterialIssue = await this.prisma.materialIssueVoucher.update({
      where: { id: materialIssueId },
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

    return updatedMaterialIssue;
  }

  async deleteMaterialIssue(materialIssueId: string): Promise<void> {
    const existingMaterialIssue =
      await this.prisma.materialIssueVoucher.findUnique({
        where: { id: materialIssueId },
      });

    if (!existingMaterialIssue) {
      throw new NotFoundException('Material Issue not found');
    }

    await this.prisma.materialIssueVoucher.delete({
      where: { id: materialIssueId },
    });
  }

  async count(where?: Prisma.MaterialIssueVoucherWhereInput): Promise<number> {
    return this.prisma.materialIssueVoucher.count({ where });
  }
}
