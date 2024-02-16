import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { MaterialReceiveService } from './material-receive.service';
import { MaterialReceiveVoucher } from './model/material-receive.model';
import { CreateMaterialReceiveInput } from './dto/create-material-receive.input';
import { UpdateMaterialReceiveInput } from './dto/update-material-receive.input';
import { FilterMaterialReceiveInput } from './dto/filter-material-receive.input';
import { OrderByMaterialReceiveInput } from './dto/order-by-material-receive.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { PaginationMaterialReceives } from 'src/common/pagination/pagination-info';
import { Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';

@Resolver('MaterialReceive')
export class MaterialReceiveResolver {
  constructor(
    private readonly materialReceiveService: MaterialReceiveService,
  ) {}

  @Query(() => PaginationMaterialReceives)
  async getMaterialReceives(
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
          OR: [
            {
              date: filterMaterialReceiveInput?.date,
            },
            {
              supplierName: filterMaterialReceiveInput?.supplierName,
            },
            {
              invoiceId: filterMaterialReceiveInput?.invoiceId,
            },
            {
              materialRequestId: filterMaterialReceiveInput?.materialRequestId,
            },
            {
              purchasedById: filterMaterialReceiveInput?.purchasedById,
            },
            {
              purchaseOrderId: filterMaterialReceiveInput?.purchaseOrderId,
            },
            {
              approvedById: filterMaterialReceiveInput?.approvedById,
            },
            {
              approved: filterMaterialReceiveInput?.approved,
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