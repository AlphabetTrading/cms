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
import { HasRoles, UserEntity } from 'src/common/decorators';
import { RolesGuard } from 'src/auth/guards/roles.guard';

@UseGuards(GqlAuthGuard, RolesGuard)
@Resolver('PurchaseOrder')
export class PurchaseOrderResolver {
  constructor(private readonly purchaseOrderService: PurchaseOrderService) {}

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
    @Args('mine', { type: () => Boolean, defaultValue: false })
    mine?: boolean,
  ): Promise<PaginationPurchaseOrders> {
    let approverIds: string[] = [];

    if (filterPurchaseOrderInput?.projectId) {
      const approvers =
        await this.purchaseOrderService.getPurchaseOrderApprovers(
          filterPurchaseOrderInput.projectId,
        );
      approverIds = approvers.flatMap((approver) =>
        approver.ProjectUsers.map((projectUser) => projectUser.userId),
      );
    }

    try {
      const baseConditions: Prisma.PurchaseOrderWhereInput[] = [
        {
          id: filterPurchaseOrderInput?.id,
        },
        {
          projectId: filterPurchaseOrderInput?.projectId,
        },
        {
          OR: [
            {
              serialNumber: filterPurchaseOrderInput?.serialNumber,
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
              status: {
                in: filterPurchaseOrderInput?.status,
              },
            },
          ],
        },
        {
          createdAt: filterPurchaseOrderInput?.createdAt,
        },
      ].filter(Boolean);

      if (mine) {
        baseConditions.push({
          OR: [
            { preparedById: user.id },
            { approvedById: user.id },
            ...(approverIds.includes(user.id)
              ? [
                  {
                    projectId: filterPurchaseOrderInput?.projectId,
                  },
                ]
              : []),
          ],
        });
      }

      const where: Prisma.PurchaseOrderWhereInput = {
        AND: baseConditions,
      };

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
  @HasRoles('PURCHASER')
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
  @HasRoles('PURCHASER')
  async updatePurchaseOrder(
    @Args('updatePurchaseOrderInput')
    updatePurchaseOrderInput: UpdatePurchaseOrderInput,
  ) {
    try {
      return this.purchaseOrderService.updatePurchaseOrder(
        updatePurchaseOrderInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating purchase order!');
    }
  }

  @Mutation(() => PurchaseOrderVoucher)
  @HasRoles('PURCHASER')
  async deletePurchaseOrder(@Args('id') purchaseOrderId: string) {
    try {
      return this.purchaseOrderService.deletePurchaseOrder(purchaseOrderId);
    } catch (e) {
      throw new BadRequestException('Error deleting purchase order!');
    }
  }

  @Mutation(() => PurchaseOrderVoucher)
  @HasRoles('PROJECT_MANAGER')
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
      throw new BadRequestException(
        e.message || 'Error approving purchase order!',
      );
    }
  }

  @Query(() => String)
  async generatePurchaseOrderPdf(@Args('id') id: string): Promise<string> {
    try {
      return await this.purchaseOrderService.generatePdf(id);
    } catch (e) {
      throw new BadRequestException(
        e.message || 'Error generating purchase order pdf!',
      );
    }
  }
}
