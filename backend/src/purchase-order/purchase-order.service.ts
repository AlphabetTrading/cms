import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreatePurchaseOrderInput } from './dto/create-purchase-order.input';
import { PurchaseOrderVoucher } from './model/purchase-order.model';
import { UpdatePurchaseOrderInput } from './dto/update-purchase-order.input';

@Injectable()
export class PurchaseOrderService {
  constructor(private prisma: PrismaService) {}

  async createPurchaseOrder(
    createPurchaseOrder: CreatePurchaseOrderInput,
  ): Promise<PurchaseOrderVoucher> {
    const createdPurchaseOrder = await this.prisma.purchaseOrder.create({
      data: {
        date: createPurchaseOrder.date,
        purchaseNumber: createPurchaseOrder.purchaseNumber,
        projectDetails: createPurchaseOrder.projectDetails,
        supplierName: createPurchaseOrder.supplierName,
        materialRequestId: createPurchaseOrder.materialRequestId,
        subTotal: createPurchaseOrder.subTotal,
        vat: createPurchaseOrder.vat,
        grandTotal: createPurchaseOrder.grandTotal,
        preparedById: createPurchaseOrder.preparedById,
        approvedById: createPurchaseOrder.approvedById,
        dateOfReceiving: createPurchaseOrder.dateOfReceiving,
        items: {
          create: createPurchaseOrder.items.map(item => ({
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

  async getPurchaseOrders(): Promise<PurchaseOrderVoucher[]> {
    const purchaseOrders = await this.prisma.purchaseOrder.findMany({
      include: {
        items: true,
      },
    });
    return purchaseOrders;
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
}
