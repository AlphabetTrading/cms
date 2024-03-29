import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { ProductService } from './product.service';
import { Product } from './model/product.model';
import { CreateProductInput } from './dto/create-product.input';
import { UpdateProductInput } from './dto/update-product.input';
import { PaginationProducts } from 'src/common/pagination/pagination-info';
import { FilterProductInput } from './dto/filter-product.input';
import { OrderByProductInput } from './dto/order-by-product.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';

@Resolver(() => Product)
export class ProductResolver {
  constructor(private readonly productService: ProductService) {}
  @Query(() => PaginationProducts)
  async getProducts(
    @Args('filterProductInput', {
      type: () => FilterProductInput,
      nullable: true,
    })
    filterProductInput?: FilterProductInput,
    @Args('orderBy', {
      type: () => OrderByProductInput,
      nullable: true,
    })
    orderBy?: OrderByProductInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ) {
    const where: Prisma.ProductWhereInput = {
      AND: [
        {
          id: filterProductInput?.id,
        },
        {
          OR: [
            {
              name: filterProductInput?.name,
            },
          ],
        },
      ],
    };

    try {
      const products = await this.productService.getProducts({
        where,
        orderBy,
        skip: paginationInput?.skip,
        take: paginationInput?.take,
      });

      const count = await this.productService.count(where);

      return {
        items: products,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading products!');
    }
  }

  @Query(() => Product)
  async getProduct(@Args('id', { type: () => String }) id: string) {
    try {
      return this.productService.getProductById(id);
    } catch (e) {
      throw new BadRequestException('Error loading product!');
    }
  }

  @Mutation(() => Product)
  async createProduct(
    @Args('createProductInput') createProductInput: CreateProductInput,
  ) {
    try {
      return this.productService.createProduct(createProductInput);
    } catch (e) {
      throw new BadRequestException('Error creating product!');
    }
  }

  @Mutation(() => Product)
  async updateProduct(
    @Args('id') productId: string,
    @Args('updateProductInput') updateProductInput: UpdateProductInput,
  ) {
    try {
      return this.productService.updateProduct(productId, updateProductInput);
    } catch (e) {
      throw new BadRequestException('Error updating product!');
    }
  }

  @Mutation(() => Product)
  async deleteProduct(@Args('id', { type: () => String }) id: string) {
    try {
      return this.productService.deleteProduct(id);
    } catch (e) {
      throw new BadRequestException('Error deleting product!');
    }
  }
}
