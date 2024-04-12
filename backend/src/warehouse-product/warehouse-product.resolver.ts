import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';
import { PaginationWarehouseProducts } from 'src/common/pagination/pagination-info';
import { CreateWarehouseProductInput } from './dto/create-warehouse-product.input';
import { FilterWarehouseProductInput } from './dto/filter-warehouse-product.input';
import { UpdateWarehouseProductInput } from './dto/update-warehouse-product.input';
import { WarehouseProduct } from './model/warehouse-product.model';
import { WarehouseProductService } from './warehouse-product.service';
import { OrderByWarehouseProductInput } from './dto/order-by-warehouse-product.input';
import { WarehouseProductStock } from './model/warehouse-product-stock.model';

@Resolver(() => WarehouseProduct)
export class WarehouseProductResolver {
  constructor(
    private readonly warehouseProductService: WarehouseProductService,
  ) {}
  @Query(() => PaginationWarehouseProducts)
  async getWarehouseProducts(
    @Args('filterWarehouseProductInput', {
      type: () => FilterWarehouseProductInput,
      nullable: true,
    })
    filterWarehouseProductInput?: FilterWarehouseProductInput,
    @Args('orderBy', {
      type: () => OrderByWarehouseProductInput,
      nullable: true,
    })
    orderBy?: OrderByWarehouseProductInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ) {
    const where: Prisma.WarehouseProductWhereInput = {
      AND: [
        {
          id: filterWarehouseProductInput?.id,
        },
        {
          productVariantId: filterWarehouseProductInput?.productVariantId,
        },
        {
          warehouseId: filterWarehouseProductInput?.warehouseId,
        },
        {
          OR: [
            {
              productVariant: {
                variant: filterWarehouseProductInput?.productVariant?.variant,
                productId:
                  filterWarehouseProductInput?.productVariant?.productId,
              },
            },
            {
              warehouse: {
                name: filterWarehouseProductInput?.warehouse?.name,
                location: filterWarehouseProductInput?.warehouse?.location,
              },
            },
          ],
        },
      ],
    };

    try {
      const warehouseProducts =
        await this.warehouseProductService.getWarehouseProducts({
          where,
          orderBy,
          skip: paginationInput?.skip,
          take: paginationInput?.take,
        });

      const count = await this.warehouseProductService.count(where);

      return {
        items: warehouseProducts,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading warehouse products!');
    }
  }

  @Query(() => WarehouseProduct)
  async getWarehouseProduct(@Args('id', { type: () => String }) id: string) {
    try {
      return this.warehouseProductService.getWarehouseProductById(id);
    } catch (e) {
      throw new BadRequestException('Error loading warehouse product!');
    }
  }

  @Mutation(() => WarehouseProduct)
  async createWarehouseProduct(
    @Args('createWarehouseProductInput')
    createWarehouseProductInput: CreateWarehouseProductInput,
  ) {
    try {
      return this.warehouseProductService.createWarehouseProduct(
        createWarehouseProductInput,
      );
    } catch (e) {
      throw new BadRequestException('Error creating warehouse product!');
    }
  }

  @Mutation(() => WarehouseProduct)
  async updateWarehouseProduct(
    @Args('id') warehouseProductId: string,
    @Args('updateWarehouseProductInput')
    updateWarehouseProductInput: UpdateWarehouseProductInput,
  ) {
    try {
      return this.warehouseProductService.updateWarehouseProduct(
        warehouseProductId,
        updateWarehouseProductInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating warehouse product!');
    }
  }

  @Mutation(() => WarehouseProduct)
  async deleteWarehouseProduct(@Args('id', { type: () => String }) id: string) {
    try {
      return this.warehouseProductService.deleteWarehouseProduct(id);
    } catch (e) {
      throw new BadRequestException('Error deleting warehouse product!');
    }
  }

  @Query(() => [WarehouseProductStock])
  async getAllWarehouseProductsStock() {
    try {
      return this.warehouseProductService.getAllWarehouseProductsStock();
    } catch (e) {
      throw new BadRequestException('Error loading warehouse product stocks!');
    }
  }
}
