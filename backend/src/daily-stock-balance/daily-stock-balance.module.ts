import { Module } from '@nestjs/common';
import { DailyStockBalanceService } from './daily-stock-balance.service';
import { DailyStockBalanceResolver } from './daily-stock-balance.resolver';

@Module({
  providers: [DailyStockBalanceResolver, DailyStockBalanceService],
  exports: [DailyStockBalanceService],
})
export class DailyStockBalanceModule {}
