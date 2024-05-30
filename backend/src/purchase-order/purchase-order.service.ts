import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreatePurchaseOrderInput } from './dto/create-purchase-order.input';
import { PurchaseOrderVoucher } from './model/purchase-order.model';
import { UpdatePurchaseOrderInput } from './dto/update-purchase-order.input';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';
import { DocumentType } from 'src/common/enums/document-type';

@Injectable()
export class PurchaseOrderService {
  constructor(private prisma: PrismaService) {}

  async createPurchaseOrder(
    createPurchaseOrder: CreatePurchaseOrderInput,
  ): Promise<PurchaseOrderVoucher> {
    const currentSerialNumber = (await this.prisma.purchaseOrder.count()) + 1;
    const serialNumber =
      'PO/' + currentSerialNumber.toString().padStart(3, '0');

    const createdPurchaseOrder = await this.prisma.purchaseOrder.create({
      data: {
        ...createPurchaseOrder,
        serialNumber: serialNumber,
        items: {
          create: createPurchaseOrder.items.map((item) => ({
            productVariantId: item.productVariantId,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            totalPrice: item.totalPrice,
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
        approvedBy: true,
        MaterialReceiveVouchers: true,
        materialRequest: true,
        preparedBy: true,
        Project: true,
      },
    });
    return createdPurchaseOrder;
  }

  async getPurchaseOrders({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.PurchaseOrderWhereInput;
    orderBy?: Prisma.PurchaseOrderOrderByWithRelationInput;
  }): Promise<PurchaseOrderVoucher[]> {
    const purchaseOrders = await this.prisma.purchaseOrder.findMany({
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
        MaterialReceiveVouchers: true,
        materialRequest: true,
        preparedBy: true,
        Project: true,
      },
    });
    return purchaseOrders;
  }

  async getPurchaseOrderCountByStatus({
    where,
  }: {
    where?: Prisma.PurchaseOrderWhereInput;
  }): Promise<any> {
    const statusCounts = await this.prisma.purchaseOrder.groupBy({
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
    documentTransaction.type = DocumentType.PURCHASE_ORDER;

    return documentTransaction;
  }

  async getPurchaseOrderById(
    purchaseOrderId: string,
  ): Promise<PurchaseOrderVoucher | null> {
    const purchaseOrder = await this.prisma.purchaseOrder.findUnique({
      where: { id: purchaseOrderId },
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
        MaterialReceiveVouchers: true,
        materialRequest: true,
        preparedBy: true,
        Project: true,
      },
    });

    return purchaseOrder;
  }

  async updatePurchaseOrder(
    input: UpdatePurchaseOrderInput,
  ): Promise<PurchaseOrderVoucher> {
    const { id: purchaseOrderId, ...updateData } = input;

    return await this.prisma.$transaction(async (prisma) => {
      const existingPurchaseOrder = await prisma.purchaseOrder.findUnique({
        where: { id: purchaseOrderId },
      });

      if (!existingPurchaseOrder) {
        throw new NotFoundException('Purchase Order not found');
      }

      const itemUpdateConditions = updateData.items.map((item) => ({
        productVariantId: item.productVariantId,
      }));

      const updatedPurchaseOrder = await prisma.purchaseOrder.update({
        where: { id: purchaseOrderId },
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
          MaterialReceiveVouchers: true,
          materialRequest: true,
          preparedBy: true,
          Project: true,
        },
      });

      return updatedPurchaseOrder;
    });
  }

  async deletePurchaseOrder(
    purchaseOrderId: string,
  ): Promise<PurchaseOrderVoucher> {
    const existingPurchaseOrder = await this.prisma.purchaseOrder.findUnique({
      where: { id: purchaseOrderId },
    });

    if (!existingPurchaseOrder) {
      throw new NotFoundException('Purchase Order not found');
    }

    await this.prisma.purchaseOrder.delete({
      where: { id: purchaseOrderId },
    });

    return existingPurchaseOrder;
  }

  async approvePurchaseOrder(
    purchaseOrderId: string,
    userId: string,
    status: ApprovalStatus,
  ) {
    const purchaseOrder = await this.prisma.purchaseOrder.findUnique({
      where: { id: purchaseOrderId },
    });

    if (!purchaseOrder) {
      throw new NotFoundException('Purchase Order not found');
    }

    if (purchaseOrder.approvedById) {
      throw new NotFoundException('Already decided on this purchase order!');
    }

    const updatedPurchaseOrder = await this.prisma.purchaseOrder.update({
      where: { id: purchaseOrderId },
      data: {
        approvedById: userId,
        status: status,
      },
    });

    return updatedPurchaseOrder;
  }

  async count(where?: Prisma.PurchaseOrderWhereInput): Promise<number> {
    return this.prisma.purchaseOrder.count({ where });
  }
}
