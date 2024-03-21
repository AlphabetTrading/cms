import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreatePurchaseOrderInput } from './dto/create-purchase-order.input';
import { PurchaseOrderVoucher } from './model/purchase-order.model';
import { UpdatePurchaseOrderInput } from './dto/update-purchase-order.input';
import { Prisma } from '@prisma/client';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';
import { DocumentType } from 'src/common/enums/document-type';

@Injectable()
export class PurchaseOrderService {
  constructor(private prisma: PrismaService) {}

  async createPurchaseOrder(
    createPurchaseOrder: CreatePurchaseOrderInput,
  ): Promise<PurchaseOrderVoucher> {
    const currentSerialNumber = await this.prisma.purchaseOrder.count();
    const serialNumber =
      'PO/' + currentSerialNumber.toString().padStart(3, '0');

    const createdPurchaseOrder = await this.prisma.purchaseOrder.create({
      data: {
        ...createPurchaseOrder,
        serialNumber: serialNumber,
        items: {
          create: createPurchaseOrder.items.map((item) => ({
            listNo: item.listNo,
            description: item.description,
            quantityRequested: item.quantityRequested,
            unitPrice: item.unitPrice,
            totalPrice: item.totalPrice,
            unitOfMeasure: item.unitOfMeasure,
            remark: item.remark,
          })),
        },
      },
      include: {
        items: true,
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
        items: true,
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

    let counts = { approved: 0, declined: 0, pending: 0 };

    counts = statusCounts.reduce((acc, { status, _count }) => {
      acc[status] = _count.status;
      return acc;
    }, counts);

    const documentTransaction = new DocumentTransaction();
    documentTransaction.approvedCount = counts.approved;
    documentTransaction.declinedCount = counts.declined;
    documentTransaction.pendingCount = counts.pending;
    documentTransaction.type = DocumentType.PURCHASE_ORDER;

    return documentTransaction;
  }

  async getPurchaseOrderById(
    purchaseOrderId: string,
  ): Promise<PurchaseOrderVoucher | null> {
    const purchaseOrder = await this.prisma.purchaseOrder.findUnique({
      where: { id: purchaseOrderId },
      include: { items: true },
    });

    return purchaseOrder;
  }

  async updatePurchaseOrder(
    purchaseOrderId: string,
    updateData: UpdatePurchaseOrderInput,
  ): Promise<PurchaseOrderVoucher> {
    const existingPurchaseOrder = await this.prisma.purchaseOrder.findUnique({
      where: { id: purchaseOrderId },
    });

    if (!existingPurchaseOrder) {
      throw new NotFoundException('Material Return not found');
    }

    const itemUpdateConditions = updateData.items.map((item) => ({
      listNo: item.listNo,
    }));

    const updatedPurchaseOrder = await this.prisma.purchaseOrder.update({
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
        items: true,
      },
    });

    return updatedPurchaseOrder;
  }

  async deletePurchaseOrder(purchaseOrderId: string): Promise<void> {
    const existingPurchaseOrder = await this.prisma.purchaseOrder.findUnique({
      where: { id: purchaseOrderId },
    });

    if (!existingPurchaseOrder) {
      throw new NotFoundException('Material Return not found');
    }

    await this.prisma.purchaseOrder.delete({
      where: { id: purchaseOrderId },
    });
  }

  async count(where?: Prisma.PurchaseOrderWhereInput): Promise<number> {
    return this.prisma.purchaseOrder.count({ where });
  }
}
