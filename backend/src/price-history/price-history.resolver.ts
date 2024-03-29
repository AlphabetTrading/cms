import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';
import { PriceHistory } from './model/price-history.model';
import { PriceHistoryService } from './price-history.service';
import { FilterPriceHistoryInput } from './dto/filter-price-history.input';
import { OrderByPriceHistoryInput } from './dto/order-by-price-history.input';
import { PaginationPriceHistories } from 'src/common/pagination/pagination-info';
import { CreatePriceHistoryInput } from './dto/create-price-history.input';
import { UpdatePriceHistoryInput } from './dto/update-price-history.input';

@Resolver(() => PriceHistory)
export class PriceHistoryResolver {
  constructor(
    private readonly priceHistoryService: PriceHistoryService,
  ) {}
  @Query(() => PaginationPriceHistories)
  async getProductPriceHistories(
    @Args('filterPriceHistoryInput', {
      type: () => FilterPriceHistoryInput,
      nullable: true,
    })
    filterPriceHistoryInput?: FilterPriceHistoryInput,
    @Args('orderBy', {
      type: () => OrderByPriceHistoryInput,
      nullable: true,
    })
    orderBy?: OrderByPriceHistoryInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ): Promise<PaginationPriceHistories> {
    const where: Prisma.PriceHistoryWhereInput = {
      AND: [
        {
          id: filterPriceHistoryInput?.id,
        },
        {
          createdAt: filterPriceHistoryInput?.createdAt,
        },
        {
          product: filterPriceHistoryInput?.product,
        },
      ],
    };

    try {
      const priceHistories = await this.priceHistoryService.getPriceHistories({
        where,
        orderBy,
        skip: paginationInput?.skip,
        take: paginationInput?.take,
      });
      const count = await this.priceHistoryService.count(where);
      return {
        items: priceHistories,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading product price histories!');
    }
  }

  @Query(() => PriceHistory)
  async getPriceHistory(@Args('id', { type: () => String }) id: string) {
    try {
      return this.priceHistoryService.getPriceHistoryById(id);
    } catch (e) {
      throw new BadRequestException('Error loading product price history!');
    }
  }

  @Mutation(() => PriceHistory)
  async createPriceHistory(
    @Args('createPriceHistoryInput')
    createPriceHistoryInput: CreatePriceHistoryInput,
  ) {
    try {
      return this.priceHistoryService.createPriceHistory(
        createPriceHistoryInput,
      );
    } catch (e) {
      throw new BadRequestException('Error creating product price history!');
    }
  }

  @Mutation(() => PriceHistory)
  async updatePriceHistory(
    @Args('id') priceHistoryId: string,
    @Args('updatePriceHistoryInput')
    updatePriceHistoryInput: UpdatePriceHistoryInput,
  ) {
    try {
      return this.priceHistoryService.updatePriceHistory(
        priceHistoryId,
        updatePriceHistoryInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating product price history!');
    }
  }

  @Mutation(() => PriceHistory)
  async deletePriceHistory(@Args('id', { type: () => String }) id: string) {
    try {
      return this.priceHistoryService.deletePriceHistory(id);
    } catch (e) {
      throw new BadRequestException('Error deleting product price history!');
    }
  }
}
