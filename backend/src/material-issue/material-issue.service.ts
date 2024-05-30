import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialIssueInput } from './dto/create-material-issue.input';
import { UpdateMaterialIssueInput } from './dto/update-material-issue.input';
import { MaterialIssueVoucher } from './model/material-issue.model';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DocumentType } from 'src/common/enums/document-type';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';

@Injectable()
export class MaterialIssueService {
  constructor(private prisma: PrismaService) {}

  async createMaterialIssue(
    createMaterialIssueInput: CreateMaterialIssueInput,
  ): Promise<MaterialIssueVoucher> {
    const lastMaterialIssueVoucher =
      await this.prisma.materialIssueVoucher.findFirst({
        select: {
          serialNumber: true,
        },
        orderBy: {
          createdAt: 'desc',
        },
      });
    let currentSerialNumber = 1;
    if (lastMaterialIssueVoucher) {
      currentSerialNumber =
        parseInt(lastMaterialIssueVoucher.serialNumber.split('/')[1]) + 1;
    }
    const serialNumber =
      'ISS/' + currentSerialNumber.toString().padStart(4, '0');

    const createdMaterialIssue = await this.prisma.materialIssueVoucher.create({
      data: {
        ...createMaterialIssueInput,
        serialNumber: serialNumber,
        items: {
          create: createMaterialIssueInput.items.map((item) => ({
            productVariantId: item.productVariantId,
            useType: item.useType,
            subStructureDescription: item.subStructureDescription,
            superStructureDescription: item.superStructureDescription,
            quantity: item.quantity,
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
        warehouseStore: true,
        approvedBy: true,
        preparedBy: true,
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
        warehouseStore: true,
        approvedBy: true,
        preparedBy: true,
      },
    });
    return materialIssues;
  }

  async getMaterialIssuesCountByStatus({
    where,
  }: {
    where?: Prisma.MaterialIssueVoucherWhereInput;
  }): Promise<any> {
    const statusCounts = await this.prisma.materialIssueVoucher.groupBy({
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
    documentTransaction.type = DocumentType.MATERIAL_ISSUE;

    return documentTransaction;
  }
  async getMaterialIssueById(
    materialIssueId: string,
  ): Promise<MaterialIssueVoucher | null> {
    const materialIssue = await this.prisma.materialIssueVoucher.findUnique({
      where: { id: materialIssueId },
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
        warehouseStore: true,
        approvedBy: true,
        preparedBy: true,
      },
    });

    return materialIssue;
  }

  async updateMaterialIssue(
    input: UpdateMaterialIssueInput,
  ): Promise<MaterialIssueVoucher> {
    const { id: materialIssueId, ...updateData } = input;

    return await this.prisma.$transaction(async (prisma) => {
      const existingMaterialIssue =
        await prisma.materialIssueVoucher.findUnique({
          where: { id: materialIssueId },
        });

      if (!existingMaterialIssue) {
        throw new NotFoundException('Material Issue not found');
      }

      const itemUpdateConditions = updateData.items.map((item) => ({
        productVariantId: item.productVariantId,
      }));

      const updatedMaterialIssue = await prisma.materialIssueVoucher.update({
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
          warehouseStore: true,
          approvedBy: true,
          preparedBy: true,
        },
      });

      return updatedMaterialIssue;
    });
  }

  async deleteMaterialIssue(
    materialIssueId: string,
  ): Promise<MaterialIssueVoucher> {
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

    return existingMaterialIssue;
  }

  async getMaterialIssueApprovers() // warehouseStoreId: string,
  // projectId?: string,
  {
    const approvers = await this.prisma.warehouseStoreManager.findMany({
      select: {
        StoreManager: true,
      },
    });

    console.log(approvers, 239)
    return approvers;
  }

  async approveMaterialIssue(
    materialIssueId: string,
    userId: string,
    status: ApprovalStatus,
  ) {
    const materialIssue = await this.prisma.materialIssueVoucher.findUnique({
      where: { id: materialIssueId },
      include: { items: true },
    });

    if (!materialIssue) {
      throw new NotFoundException('Material Issue not found');
    }

    if (materialIssue.approvedById) {
      throw new NotFoundException('Already decided on this material issue!');
    }

    if (status === ApprovalStatus.COMPLETED) {
      await this.prisma.$transaction(async (prisma) => {
        for (const item of materialIssue.items) {
          const stock = await prisma.warehouseProduct.findUnique({
            where: {
              productVariantId_warehouseId_projectId: {
                productVariantId: item.productVariantId,
                warehouseId: materialIssue.warehouseStoreId,
                projectId: materialIssue.projectId,
              },
            },
          });

          if (!stock || stock.quantity < item.quantity) {
            throw new ConflictException(
              `Not enough stock available for product variant ID ${item.productVariantId}`,
            );
          }

          await prisma.warehouseProduct.update({
            where: {
              id: stock.id,
              version: stock.version,
            },
            data: {
              quantity: stock.quantity - item.quantity,
              version: stock.version + 1,
            },
          });
        }
        const updatedMaterialIssue = await prisma.materialIssueVoucher.update({
          where: { id: materialIssueId },
          data: { status: status, approvedById: userId },
        });

        return updatedMaterialIssue;
      });
    } else {
      const updatedMaterialIssue =
        await this.prisma.materialIssueVoucher.update({
          where: { id: materialIssueId },
          data: {
            approvedById: userId,
            status: status,
          },
        });
      return updatedMaterialIssue;
    }
  }

  async count(where?: Prisma.MaterialIssueVoucherWhereInput): Promise<number> {
    return this.prisma.materialIssueVoucher.count({ where });
  }
}
