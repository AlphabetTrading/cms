import { Resolver, Query, Mutation, Args, Int } from '@nestjs/graphql';
import { DailyStockBalanceService } from './daily-stock-balance.service';
import { DailyStockBalance } from './model/daily-stock-balance.model';
import { CreateDailyStockBalanceInput } from './dto/create-daily-stock-balance.input';
import { UpdateDailyStockBalanceInput } from './dto/update-daily-stock-balance.input';

@Resolver(() => DailyStockBalance)
export class DailyStockBalanceResolver {
  constructor(private readonly dailyStockBalanceService: DailyStockBalanceService) {}

  @Mutation(() => DailyStockBalance)
  createDailyStockBalance(@Args('createDailyStockBalanceInput') createDailyStockBalanceInput: CreateDailyStockBalanceInput) {
    return this.dailyStockBalanceService.create(createDailyStockBalanceInput);
  }

  @Query(() => [DailyStockBalance], { name: 'dailyStockBalance' })
  findAll() {
    return this.dailyStockBalanceService.findAll();
  }

  @Query(() => DailyStockBalance, { name: 'dailyStockBalance' })
  findOne(@Args('id', { type: () => Int }) id: number) {
    return this.dailyStockBalanceService.findOne(id);
  }

  @Mutation(() => DailyStockBalance)
  updateDailyStockBalance(@Args('updateDailyStockBalanceInput') updateDailyStockBalanceInput: UpdateDailyStockBalanceInput) {
    return this.dailyStockBalanceService.update(updateDailyStockBalanceInput.id, updateDailyStockBalanceInput);
  }

  @Mutation(() => DailyStockBalance)
  removeDailyStockBalance(@Args('id', { type: () => Int }) id: number) {
    return this.dailyStockBalanceService.remove(id);
  }
}
