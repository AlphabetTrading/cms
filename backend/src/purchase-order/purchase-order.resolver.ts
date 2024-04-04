import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { PurchaseOrderService } from './purchase-order.service';
import { PurchaseOrderVoucher } from './model/purchase-order.model';
import { CreatePurchaseOrderInput } from './dto/create-purchase-order.input';
import { UpdatePurchaseOrderInput } from './dto/update-purchase-order.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { FilterPurchaseOrderInput } from './dto/filter-purchase-order.input';
import { OrderByPurchaseOrderInput } from './dto/order-by-purchase-order.input';
import { PaginationPurchaseOrders } from 'src/common/pagination/pagination-info';
import { ApprovalStatus, Prisma, User } from '@prisma/client';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';
import { UserEntity } from 'src/common/decorators';

@Resolver('PurchaseOrder')
export class PurchaseOrderResolver {
  constructor(private readonly purchaseOrderService: PurchaseOrderService) {}

  @UseGuards(GqlAuthGuard)
  @Query(() => PaginationPurchaseOrders)
  async getPurchaseOrders(
    @UserEntity() user: User,
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
          projectId: filterPurchaseOrderInput?.projectId
        },
        {
          OR: [
            {
              preparedById: user.id,
            },
            {
              approvedById: user.id,
            },
          ],
        },

        {
          OR: [
            {
              serialNumber: filterPurchaseOrderInput?.serialNumber,
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
              preparedById: filterPurchaseOrderInput?.preparedById || user.id,
            },
            {
              approvedById: filterPurchaseOrderInput?.approvedById || user.id,
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

  
  @Mutation(() => PurchaseOrderVoucher)
  async approvePurchaseOrder(
    @UserEntity() user: User,
    @Args('purchaseOrderId') purchaseOrderId: string,
    @Args('decision', { type: () => ApprovalStatus })
    decision: ApprovalStatus,
  ) {
    try {
      return this.purchaseOrderService.approvePurchaseOrder(
        purchaseOrderId,
        user.id,
        decision,
      );
    } catch (e) {
      throw new BadRequestException('Error approving purchase order!');
    }
  }

}
