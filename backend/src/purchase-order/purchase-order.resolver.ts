import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { PurchaseOrderService } from './purchase-order.service';
import { PurchaseOrderVoucher } from './model/purchase-order.model';
import { CreatePurchaseOrderInput } from './dto/create-purchase-order.input';
import { UpdatePurchaseOrderInput } from './dto/update-purchase-order.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { FilterPurchaseOrderInput } from './dto/filter-purchase-order.input';
import { OrderByPurchaseOrderInput } from './dto/order-by-purchase-order.input';
import { PaginationPurchaseOrders } from 'src/common/pagination/pagination-info';
import { Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';

@Resolver('PurchaseOrder')
export class PurchaseOrderResolver {
  constructor(private readonly purchaseOrderService: PurchaseOrderService) {}

  @Query(() => PaginationPurchaseOrders)
  async getPurchaseOrders(
    @Args('filterPurchaseOrderInput', {
      type: () => FilterPurchaseOrderInput,
      nullable: true,
    })
    filterPurchaseOrderInput?: FilterPurchaseOrderInput,
    @Args('orderBy', {
      type: () => OrderByPurchaseOrderInput,
      nullable: true,
    })
    orderBy?: OrderByPurchaseOrderInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ): Promise<PaginationPurchaseOrders> {
    const where: Prisma.PurchaseOrderWhereInput = {
      AND: [
        {
          id: filterPurchaseOrderInput?.id,
        },
        {
          OR: [
            {
              serialNumber: filterPurchaseOrderInput?.serialNumber,
            },
            {
              dateOfReceiving: filterPurchaseOrderInput?.dateOfReceiving,
            },
            {
              materialRequestId: filterPurchaseOrderInput?.materialRequestId,
            },
            {
              materialRequest: filterPurchaseOrderInput?.materialRequest,
            },
            {
              supplierName: filterPurchaseOrderInput?.supplierName,
            },
            {
              subTotal: filterPurchaseOrderInput?.subTotal,
            },
            {
              preparedById: filterPurchaseOrderInput?.preparedById,
            },
            {
              approvedById: filterPurchaseOrderInput?.approvedById,
            },
            {
              preparedBy: filterPurchaseOrderInput?.preparedBy,
            },
            {
              approvedBy: filterPurchaseOrderInput?.approvedBy,
            },
            {
              status: filterPurchaseOrderInput?.status,
            },
          ],
        },
        {
          createdAt: filterPurchaseOrderInput?.createdAt,
        },
      ],
    };

    try {
      const purchaseOrders = await this.purchaseOrderService.getPurchaseOrders({
        where,
        orderBy,
        skip: paginationInput?.skip,
        take: paginationInput?.take,
      });

      const count = await this.purchaseOrderService.count(where);

      return {
        items: purchaseOrders,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading purchase orders!');
    }
  }

  @Query(() => PurchaseOrderVoucher)
  async getPurchaseOrderById(@Args('id') purchaseOrderId: string) {
    try {
      return this.purchaseOrderService.getPurchaseOrderById(purchaseOrderId);
    } catch (e) {
      throw new BadRequestException('Error loading purchase order!');
    }
  }

  @Mutation(() => PurchaseOrderVoucher)
  async createPurchaseOrder(
    @Args('createPurchaseOrderInput')
    createPurchaseOrder: CreatePurchaseOrderInput,
  ) {
    try {
      return await this.purchaseOrderService.createPurchaseOrder(
        createPurchaseOrder,
      );
    } catch (e) {
      throw new BadRequestException('Error creating purchase order!');
    }
  }

  @Mutation(() => PurchaseOrderVoucher)
  async updatePurchaseOrder(
    @Args('id') purchaseOrderId: string,
    @Args('updatePurchaseOrderInput')
    updatePurchaseOrderInput: UpdatePurchaseOrderInput,
  ) {
    try {
      return this.purchaseOrderService.updatePurchaseOrder(
        purchaseOrderId,
        updatePurchaseOrderInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating purchase order!');
    }
  }

  @Mutation(() => PurchaseOrderVoucher)
  async deletePurchaseOrder(@Args('id') purchaseOrderId: string) {
    try {
      return this.purchaseOrderService.deletePurchaseOrder(purchaseOrderId);
    } catch (e) {
      throw new BadRequestException('Error deleting purchase order!');
    }
  }
}
