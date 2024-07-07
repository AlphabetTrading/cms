import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';
import { PriceHistory } from './model/price-history.model';
import { PriceHistoryService } from './price-history.service';
import { FilterPriceHistoryInput } from './dto/filter-price-history.input';
import { PaginationPriceHistories } from 'src/common/pagination/pagination-info';
import { CreatePriceHistoryInput } from './dto/create-price-history.input';

@Resolver(() => PriceHistory)
export class PriceHistoryResolver {
  constructor(private readonly priceHistoryService: PriceHistoryService) {}
  @Query(() => PaginationPriceHistories)
  async getProductPriceHistories(
    @Args('filterPriceHistoryInput', {
      type: () => FilterPriceHistoryInput
    })
    filterPriceHistoryInput: FilterPriceHistoryInput,
  ): Promise<PaginationPriceHistories> {
    const where: Prisma.PriceHistoryWhereInput = {
      AND: [
        {
          id: filterPriceHistoryInput?.id,
        },
        {
          companyId: filterPriceHistoryInput?.companyId,
        },
        {
          company: filterPriceHistoryInput?.company,
        },
        {
          productVariantId: filterPriceHistoryInput?.productVariantId,
        },
        {
          productVariant: filterPriceHistoryInput?.productVariant,
        },
      ],
    };

    try {
      const priceHistories = await this.priceHistoryService.getPriceHistories({
        where,
      });
      const count = await this.priceHistoryService.count(where);
      return {
        items: priceHistories,
        meta: {
          count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading product price histories!');
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
}
