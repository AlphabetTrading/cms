import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialRequestInput } from './dto/create-material-request.input';
import { MaterialRequestVoucher } from './model/material-request.model';
import { UpdateMaterialRequestInput } from './dto/update-material-request.input';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';
import { DocumentType } from 'src/common/enums/document-type';

@Injectable()
export class MaterialRequestService {
  constructor(private prisma: PrismaService) {}

  async createMaterialRequest(
    createMaterialRequest: CreateMaterialRequestInput,
  ): Promise<MaterialRequestVoucher> {
    const currentSerialNumber =
      (await this.prisma.materialRequestVoucher.count()) + 1;
    const serialNumber =
      'MRQ/' + currentSerialNumber.toString().padStart(3, '0');

    const createdMaterialRequest =
      await this.prisma.materialRequestVoucher.create({
        data: {
          ...createMaterialRequest,
          serialNumber: serialNumber,
          items: {
            create: createMaterialRequest.items.map((item) => ({
              productVariantId: item.productVariantId,
              quantity: item.quantity,
              remark: item.remark,
            })),
          },
        },
        include: {
          items: true,
          approvedBy: true,
          requestedBy: true,
          MaterialReceiveVouchers: true,
          Proforma: true,
          Project: true,
          PurchaseOrders: true,
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
        items: {
          include: {
            productVariant: {
              include: {
                product: true,
              },
            },
          },
        },
        approvedBy: true,
        requestedBy: true,
        MaterialReceiveVouchers: true,
        Proforma: true,
        Project: true,
        PurchaseOrders: true,
      },
    });
    return materialRequests;
  }

  async getMaterialRequestCountByStatus({
    where,
  }: {
    where?: Prisma.MaterialRequestVoucherWhereInput;
  }): Promise<any> {
    const statusCounts = await this.prisma.materialRequestVoucher.groupBy({
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
    documentTransaction.type = DocumentType.MATERIAL_REQUEST;

    return documentTransaction;
  }

  async getMaterialRequestById(
    materialRequestId: string,
  ): Promise<MaterialRequestVoucher | null> {
    const materialRequest = await this.prisma.materialRequestVoucher.findUnique(
      {
        where: { id: materialRequestId },
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
          approvedBy: true,
          requestedBy: true,
          MaterialReceiveVouchers: true,
          Proforma: true,
          Project: true,
          PurchaseOrders: true,
        },
      },
    );

    return materialRequest;
  }

  async updateMaterialRequest(
    input: UpdateMaterialRequestInput,
  ): Promise<MaterialRequestVoucher> {
    const { id: materialRequestId, ...updateData } = input;

    return await this.prisma.$transaction(async (prisma) => {
      const existingMaterialRequest =
        await prisma.materialRequestVoucher.findUnique({
          where: { id: materialRequestId },
        });

      if (!existingMaterialRequest) {
        throw new NotFoundException('Material Request not found');
      }

      const itemUpdateConditions = updateData.items.map((item) => ({
        productVariantId: item.productVariantId,
      }));

      const updatedMaterialRequest = await prisma.materialRequestVoucher.update(
        {
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
            items: {
              include: {
                productVariant: {
                  include: {
                    product: true,
                  },
                },
              },
            },
            approvedBy: true,
            requestedBy: true,
            MaterialReceiveVouchers: true,
            Proforma: true,
            Project: true,
            PurchaseOrders: true,
          },
        },
      );

      return updatedMaterialRequest;
    });
  }

  async deleteMaterialRequest(
    materialRequestId: string,
  ): Promise<MaterialRequestVoucher> {
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

    return existingMaterialRequest;
  }

  async approveMaterialRequest(
    materialRequestId: string,
    userId: string,
    status: ApprovalStatus,
  ) {
    const materialRequest = await this.prisma.materialRequestVoucher.findUnique(
      {
        where: { id: materialRequestId },
      },
    );

    if (!materialRequest) {
      throw new NotFoundException('Material Request not found');
    }

    if (materialRequest.approvedById) {
      throw new NotFoundException('Already decided on this material request!');
    }

    const updatedMaterialRequest =
      await this.prisma.materialRequestVoucher.update({
        where: { id: materialRequestId },
        data: {
          approvedById: userId,
          status: status,
        },
      });

    return updatedMaterialRequest;
  }

  async count(
    where?: Prisma.MaterialRequestVoucherWhereInput,
  ): Promise<number> {
    return this.prisma.materialRequestVoucher.count({ where });
  }
}
