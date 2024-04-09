import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';
import { ProductVariant } from './model/product-variant.model';
import { ProductVariantService } from './product-variant.service';
import { PaginationProductVariants } from 'src/common/pagination/pagination-info';
import { FilterProductVariantInput } from './dto/filter-product-variant.input';
import { OrderByProductVariantInput } from './dto/order-by-product-variant.input';
import { CreateProductVariantInput } from './dto/create-product-variant.input';
import { UpdateProductVariantInput } from './dto/update-product-variant.input';

@Resolver(() => ProductVariant)
export class ProductVariantResolver {
  constructor(private readonly productVariantService: ProductVariantService) {}
  @Query(() => PaginationProductVariants)
  async getProductVariants(
    @Args('filterProductVariantInput', {
      type: () => FilterProductVariantInput,
      nullable: true,
    })
    filterProductVariantInput?: FilterProductVariantInput,
    @Args('orderBy', {
      type: () => OrderByProductVariantInput,
      nullable: true,
    })
    orderBy?: OrderByProductVariantInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ) {
    const where: Prisma.ProductVariantWhereInput = {
      AND: [
        {
          id: filterProductVariantInput?.id,
        },
        {
          OR: [
            {
              productId: filterProductVariantInput.productId,
            },
            {
              variant: filterProductVariantInput?.variant,
            },
          ],
        },
        {
          createdAt: filterProductVariantInput?.createdAt,
        },
      ],
    };

    try {
      const productVariants =
        await this.productVariantService.getProductVariants({
          where,
          orderBy,
          skip: paginationInput?.skip,
          take: paginationInput?.take,
        });

      const count = await this.productVariantService.count(where);

      return {
        items: productVariants,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading product variants!');
    }
  }

  @Query(() => ProductVariant)
  async getProductVariant(@Args('id', { type: () => String }) id: string) {
    try {
      return this.productVariantService.getProductVariantById(id);
    } catch (e) {
      throw new BadRequestException('Error loading product variant!');
    }
  }

  @Mutation(() => ProductVariant)
  async createProductVariant(
    @Args('createProductVariantInput')
    createProductVariantInput: CreateProductVariantInput,
  ) {
    try {
      return this.productVariantService.createProductVariant(
        createProductVariantInput,
      );
    } catch (e) {
      throw new BadRequestException('Error creating product variant!');
    }
  }

  @Mutation(() => ProductVariant)
  async updateProductVariant(
    @Args('id') productVariantId: string,
    @Args('updateProductVariantInput')
    updateProductVariantInput: UpdateProductVariantInput,
  ) {
    try {
      return this.productVariantService.updateProductVariant(
        productVariantId,
        updateProductVariantInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating product variant!');
    }
  }

  @Mutation(() => ProductVariant)
  async deleteProductVariant(@Args('id', { type: () => String }) id: string) {
    try {
      return this.productVariantService.deleteProductVariant(id);
    } catch (e) {
      throw new BadRequestException('Error deleting product variant!');
    }
  }
}
