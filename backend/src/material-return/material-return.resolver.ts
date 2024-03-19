import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { MaterialReturnService } from './material-return.service';
import { MaterialReturnVoucher } from './model/material-return.model';
import { CreateMaterialReturnInput } from './dto/create-material-return.input';
import { UpdateMaterialReturnInput } from './dto/update-material-return.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { FilterMaterialReturnInput } from './dto/filter-material-return.input';
import { OrderByMaterialReturnInput } from './dto/order-by-material-return.input';
import { BadRequestException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PaginationMaterialReturns } from 'src/common/pagination/pagination-info';

@Resolver('MaterialReturn')
export class MaterialReturnResolver {
  constructor(private readonly materialReturnService: MaterialReturnService) {}

  @Query(() => PaginationMaterialReturns)
  async getMaterialReturns(
    @Args('filterMaterialReturnInput', {
      type: () => FilterMaterialReturnInput,
      nullable: true,
    })
    filterMaterialReturnInput?: FilterMaterialReturnInput,
    @Args('orderBy', {
      type: () => OrderByMaterialReturnInput,
      nullable: true,
    })
    orderBy?: OrderByMaterialReturnInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ) {
    const where: Prisma.MaterialReturnVoucherWhereInput = {
      AND: [
        {
          id: filterMaterialReturnInput?.id,
        },
        {
          OR: [
            {
              date: filterMaterialReturnInput?.date,
            },
            {
              from: filterMaterialReturnInput?.from,
            },
            {
              receivingStore: filterMaterialReturnInput?.receivingStore,
            },
            {
              receivedById: filterMaterialReturnInput?.receivedById,
            },
            {
              returnedById: filterMaterialReturnInput?.returnedById,
            },
            {
              status: filterMaterialReturnInput?.status,
            }
          ],
        },
        {
          createdAt: filterMaterialReturnInput?.createdAt,
        },
      ],
    };

    try {
      const materialReturns =
        await this.materialReturnService.getMaterialReturns({
          where,
          orderBy,
          skip: paginationInput?.skip,
          take: paginationInput?.take,
        });

      const count = await this.materialReturnService.count(where);

      return {
        items: materialReturns,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading material returns!');
    }
  }

  @Query(() => MaterialReturnVoucher)
  async getMaterialReturnById(@Args('id') materialReturnId: string) {
    try {
      return this.materialReturnService.getMaterialReturnById(materialReturnId);
    } catch (e) {
      throw new BadRequestException('Error loading material return!');
    }
  }

  @Mutation(() => MaterialReturnVoucher)
  async createMaterialReturn(
    @Args('createMaterialReturnInput')
    createMaterialReturn: CreateMaterialReturnInput,
  ) {
    try {
      return await this.materialReturnService.createMaterialReturn(
        createMaterialReturn,
      );
    } catch (e) {
      throw new BadRequestException('Error creating material return!');
    }
  }

  @Mutation(() => MaterialReturnVoucher)
  async updateMaterialReturn(
    @Args('id') materialReturnId: string,
    @Args('updateMaterialReturnInput')
    updateMaterialReturnInput: UpdateMaterialReturnInput,
  ) {
    try {
      return this.materialReturnService.updateMaterialReturn(
        materialReturnId,
        updateMaterialReturnInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating material return!');
    }
  }

  @Mutation(() => MaterialReturnVoucher)
  async deleteMaterialReturn(@Args('id') materialReturnId: string) {
    try {
      return this.materialReturnService.deleteMaterialReturn(materialReturnId);
    } catch (e) {
      throw new BadRequestException('Error deleting material return!');
    }
  }
}
