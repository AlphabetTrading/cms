import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';
import { CreateProductUseInput } from './dto/create-product-use.input';
import { UpdateProductUseInput } from './dto/update-product-use.input';
import { ProductUse } from './model/product-use.model';
import { ProductUseService } from './product-use.service';
import { PaginationProductUses } from 'src/common/pagination/pagination-info';
import { FilterProductUseInput } from './dto/filter-product-use.input';
import { OrderByProductUseInput } from './dto/order-by-product-use.input';

@Resolver(() => ProductUse)
export class ProductUseResolver {
  constructor(private readonly productUseService: ProductUseService) {}
  @Query(() => PaginationProductUses)
  async getProductUses(
    @Args('filterProductUseInput', {
      type: () => FilterProductUseInput,
      nullable: true,
    })
    filterProductUseInput?: FilterProductUseInput,
    @Args('orderBy', {
      type: () => OrderByProductUseInput,
      nullable: true,
    })
    orderBy?: OrderByProductUseInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ) {
    const where: Prisma.ProductUseWhereInput = {
      AND: [
        {
          id: filterProductUseInput?.id,
        },
        {
          OR: [
            {
              productVariantId: filterProductUseInput.productVariantId,
            },
            {
              productVariant: filterProductUseInput.productVariant,
            },

            {
              subStructureDescription:
                filterProductUseInput.subStructureDescription,
            },

            {
              superStructureDescription:
                filterProductUseInput.superStructureDescription,
            },

            {
              useType: filterProductUseInput.useType,
            },
          ],
        },
        {
          createdAt: filterProductUseInput?.createdAt,
        },
      ],
    };

    try {
      const productUses = await this.productUseService.getProductUses({
        where,
        orderBy,
        skip: paginationInput?.skip,
        take: paginationInput?.take,
      });

      const count = await this.productUseService.count(where);

      return {
        items: productUses,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading product uses!');
    }
  }

  @Query(() => ProductUse)
  async getProductUse(@Args('id', { type: () => String }) id: string) {
    try {
      return this.productUseService.getProductUseById(id);
    } catch (e) {
      throw new BadRequestException('Error loading product use!');
    }
  }

  @Mutation(() => ProductUse)
  async createProductUse(
    @Args('createProductUseInput') createProductUseInput: CreateProductUseInput,
  ) {
    try {
      return this.productUseService.createProductUse(createProductUseInput);
    } catch (e) {
      throw new BadRequestException('Error creating product use!');
    }
  }

  @Mutation(() => ProductUse)
  async updateProductUse(
    @Args('id') productUseId: string,
    @Args('updateProductUseInput') updateProductUseInput: UpdateProductUseInput,
  ) {
    try {
      return this.productUseService.updateProductUse(
        productUseId,
        updateProductUseInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating product use!');
    }
  }

  @Mutation(() => ProductUse)
  async deleteProductUse(@Args('id', { type: () => String }) id: string) {
    try {
      return this.productUseService.deleteProductUse(id);
    } catch (e) {
      throw new BadRequestException('Error deleting product use!');
    }
  }
}
