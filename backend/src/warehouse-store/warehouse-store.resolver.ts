import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';
import { PaginationWarehouseStores } from 'src/common/pagination/pagination-info';
import { CreateWarehouseStoreInput } from './dto/create-warehouse-store.input';
import { UpdateWarehouseStoreInput } from './dto/update-warehouse-store.input';
import { WarehouseStore } from './model/warehouse-store.model';
import { WarehouseStoreService } from './warehouse-store.service';
import { FilterWarehouseStoreInput } from './dto/filter-warehouse-store.input';
import { OrderByWarehouseStoreInput } from './dto/order-by-warehouse-store.input';

@Resolver(() => WarehouseStore)
export class WarehouseStoreResolver {
  constructor(private readonly warehouseStoreService: WarehouseStoreService) {}
  @Query(() => PaginationWarehouseStores)
  async getWarehouseStores(
    @Args('filterWarehouseStoreInput', {
      type: () => FilterWarehouseStoreInput,
      nullable: true,
    })
    filterWarehouseStoreInput?: FilterWarehouseStoreInput,
    @Args('orderBy', {
      type: () => OrderByWarehouseStoreInput,
      nullable: true,
    })
    orderBy?: OrderByWarehouseStoreInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ) {
    const where: Prisma.WarehouseStoreWhereInput = {
      AND: [
        {
          id: filterWarehouseStoreInput?.id,
        },
        {
          OR: [
            {
              name: filterWarehouseStoreInput?.name,
            },
            {
              location: filterWarehouseStoreInput?.location,
            },
            {
              companyId: filterWarehouseStoreInput?.companyId,
            },
            {
              company: filterWarehouseStoreInput?.company,
            },
          ],
        },
      ],
    };

    try {
      const warehouseStores =
        await this.warehouseStoreService.getWarehouseStores({
          where,
          orderBy,
          skip: paginationInput?.skip,
          take: paginationInput?.take,
        });

      const count = await this.warehouseStoreService.count(where);

      return {
        items: warehouseStores,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading warehouse stores!');
    }
  }

  @Query(() => WarehouseStore)
  async getWarehouseStore(@Args('id', { type: () => String }) id: string) {
    try {
      return this.warehouseStoreService.getWarehouseStoreById(id);
    } catch (e) {
      throw new BadRequestException('Error loading warehouse store!');
    }
  }

  @Mutation(() => WarehouseStore)
  async createWarehouseStore(
    @Args('createWarehouseStoreInput')
    createWarehouseStoreInput: CreateWarehouseStoreInput,
  ) {
    try {
      return this.warehouseStoreService.createWarehouseStore(
        createWarehouseStoreInput,
      );
    } catch (e) {
      throw new BadRequestException('Error creating warehouse store!');
    }
  }

  @Mutation(() => WarehouseStore)
  async updateWarehouseStore(
    @Args('id') warehouseStoreId: string,
    @Args('updateWarehouseStoreInput')
    updateWarehouseStoreInput: UpdateWarehouseStoreInput,
  ) {
    try {
      return this.warehouseStoreService.updateWarehouseStore(
        warehouseStoreId,
        updateWarehouseStoreInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating warehouse store!');
    }
  }

  @Mutation(() => WarehouseStore)
  async deleteWarehouseStore(@Args('id', { type: () => String }) id: string) {
    try {
      return this.warehouseStoreService.deleteWarehouseStore(id);
    } catch (e) {
      throw new BadRequestException('Error deleting warehouse store!');
    }
  }
}
