import { Args, Query, Resolver } from '@nestjs/graphql';
import { StatService } from './stat.service';
import { BadRequestException } from '@nestjs/common';
import { DashboardStat, DetailedStockStat } from './model/stat.model';
import { FilterExpenseInput } from './dto/filter-expense.input';
import { FilterStockInput } from './dto/filter-stock.input';

@Resolver()
export class StatResolver {
  constructor(private readonly statService: StatService) {}

  @Query(() => DashboardStat)
  async getDashboardStats(@Args('id') projectId: string) {
    try {
      return this.statService.getDashboardStats(projectId);
    } catch (e) {
      throw new BadRequestException('Error loading stats!');
    }
  }

  @Query(() => Number)
  async getDetailedExpenseStats(
    @Args('filterExpenseInput', {
      type: () => FilterExpenseInput,
    })
    filterExpenseInput: FilterExpenseInput,
  ) {
    try {
      return this.statService.getDetailedExpenseStats(filterExpenseInput);
    } catch (e) {
      throw new BadRequestException('Error loading stats!');
    }
  }

  @Query(() => DetailedStockStat)
  async getDetailedStockStats(
    @Args('filterStockInput', {
      type: () => FilterStockInput,
    })
    filterStockInput: FilterStockInput,
  ) {
    try {
      return this.statService.getDetailedStockStats(filterStockInput);
    } catch (e) {
      throw new BadRequestException('Error loading stats!');
    }
  }
}
