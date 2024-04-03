import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { MaterialReceiveService } from './material-receive.service';
import { MaterialReceiveVoucher } from './model/material-receive.model';
import { CreateMaterialReceiveInput } from './dto/create-material-receive.input';
import { UpdateMaterialReceiveInput } from './dto/update-material-receive.input';
import { FilterMaterialReceiveInput } from './dto/filter-material-receive.input';
import { OrderByMaterialReceiveInput } from './dto/order-by-material-receive.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { PaginationMaterialReceives } from 'src/common/pagination/pagination-info';
import { Prisma, User } from '@prisma/client';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';
import { UserEntity } from 'src/common/decorators';

@Resolver('MaterialReceive')
export class MaterialReceiveResolver {
  constructor(
    private readonly materialReceiveService: MaterialReceiveService,
  ) {}
  
  @UseGuards(GqlAuthGuard)
  @Query(() => PaginationMaterialReceives)
  async getMaterialReceives(
    @UserEntity() user: User,
    @Args('filterMaterialReceiveInput', {
      type: () => FilterMaterialReceiveInput,
      nullable: true,
    })
    filterMaterialReceiveInput?: FilterMaterialReceiveInput,
    @Args('orderBy', {
      type: () => OrderByMaterialReceiveInput,
      nullable: true,
    })
    orderBy?: OrderByMaterialReceiveInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ): Promise<PaginationMaterialReceives> {
    const where: Prisma.MaterialReceiveVoucherWhereInput = {
      AND: [
        {
          id: filterMaterialReceiveInput?.id,
        },
        {
          projectId: filterMaterialReceiveInput.projectId
        },
        {
          OR: [
            {
              purchasedById: user.id,
            },
            {
              approvedById: user.id,
            },
          ],
        },
        {
          OR: [
            {
              supplierName: filterMaterialReceiveInput?.supplierName,
            },
            {
              serialNumber: filterMaterialReceiveInput?.serialNumber,
            },
            {
              invoiceId: filterMaterialReceiveInput?.invoiceId,
            },
            {
              materialRequestId: filterMaterialReceiveInput?.materialRequestId,
            },
            {
              materialRequest: filterMaterialReceiveInput?.materialRequest,
            },
            {
              purchasedById: filterMaterialReceiveInput?.purchasedById || user.id,
            },
            {
              purchasedBy: filterMaterialReceiveInput?.purchasedBy,
            },
            {
              purchaseOrderId: filterMaterialReceiveInput?.purchaseOrderId,
            },
            {
              purchaseOrder: filterMaterialReceiveInput?.purchaseOrder,
            },
            {
              approvedById: filterMaterialReceiveInput?.approvedById || user.id,
            },
            {
              approvedBy: filterMaterialReceiveInput?.approvedBy,
            },
            {
              status: filterMaterialReceiveInput?.status,
            },
          ],
        },
        {
          createdAt: filterMaterialReceiveInput?.createdAt,
        },
      ],
    };

    try {
      const materialReceives =
        await this.materialReceiveService.getMaterialReceives({
          where,
          orderBy,
          skip: paginationInput?.skip,
          take: paginationInput?.take,
        });

      const count = await this.materialReceiveService.count(where);
      return {
        items: materialReceives,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading material receives!');
    }
  }

  @Query(() => MaterialReceiveVoucher)
  async getMaterialReceiveById(@Args('id') materialReceiveId: string) {
    try {
      return this.materialReceiveService.getMaterialReceiveById(
        materialReceiveId,
      );
    } catch (e) {
      throw new BadRequestException('Error loading material receive!');
    }
  }

  @Mutation(() => MaterialReceiveVoucher)
  async createMaterialReceive(
    @Args('createMaterialReceiveInput')
    createMaterialReceive: CreateMaterialReceiveInput,
  ) {
    try {
      return await this.materialReceiveService.createMaterialReceive(
        createMaterialReceive,
      );
    } catch (e) {
      throw new BadRequestException('Error creating material receive!');
    }
  }

  @Mutation(() => MaterialReceiveVoucher)
  async updateMaterialReceive(
    @Args('id') materialReceiveId: string,
    @Args('updateMaterialReceiveInput')
    updateMaterialReceiveInput: UpdateMaterialReceiveInput,
  ) {
    try {
      return this.materialReceiveService.updateMaterialReceive(
        materialReceiveId,
        updateMaterialReceiveInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating material receive!');
    }
  }

  @Mutation(() => MaterialReceiveVoucher)
  async deleteMaterialReceive(@Args('id') materialReceiveId: string) {
    try {
      return this.materialReceiveService.deleteMaterialReceive(
        materialReceiveId,
      );
    } catch (e) {
      throw new BadRequestException('Error deleting material receive!');
    }
  }
}
