import { Resolver, Query, Args } from '@nestjs/graphql';
import { DailyStockBalanceService } from './daily-stock-balance.service';
import { DailyStockBalance } from './model/daily-stock-balance.model';
import { PaginationDailyStockBalances } from 'src/common/pagination/pagination-info';
import { UserEntity } from 'src/common/decorators';
import { Prisma, User } from '@prisma/client';
import { FilterDailyStockBalanceInput } from './dto/filter-daily-stock-balance.input';
import { OrderByDailyStockBalanceInput } from './dto/order-by-daily-stock-balance.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { BadRequestException } from '@nestjs/common';

@Resolver(() => DailyStockBalance)
export class DailyStockBalanceResolver {
  constructor(
    private readonly dailyStockBalanceService: DailyStockBalanceService,
  ) {}

  @Query(() => PaginationDailyStockBalances)
  async getDailyStockBalances(
    @UserEntity() user: User,
    @Args('filterDailyStockBalanceInput', {
      type: () => FilterDailyStockBalanceInput,
      nullable: true,
    })
    filterDailyStockBalanceInput?: FilterDailyStockBalanceInput,
    @Args('orderBy', {
      type: () => OrderByDailyStockBalanceInput,
      nullable: true,
    })
    orderBy?: OrderByDailyStockBalanceInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ): Promise<PaginationDailyStockBalances> {
    try {
      const where: Prisma.DailyStockBalanceWhereInput = {
        AND: [
          {
            id: filterDailyStockBalanceInput?.id,
          },
          {
            projectId: filterDailyStockBalanceInput?.projectId,
          },
          {
            createdAt: filterDailyStockBalanceInput?.createdAt,
          },
          {
            updatedAt: filterDailyStockBalanceInput?.updatedAt,
          },
        ],
      };

      const dailyStockBalances =
        await this.dailyStockBalanceService.getDailyStockBalances({
          where,
          orderBy,
          skip: paginationInput?.skip,
          take: paginationInput?.take,
        });

      const count = await this.dailyStockBalanceService.count(where);

      return {
        items: dailyStockBalances,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading daily stock balances!');
    }
  }
}
