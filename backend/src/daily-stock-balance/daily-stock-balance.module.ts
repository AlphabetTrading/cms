import { Module } from '@nestjs/common';
import { DailyStockBalanceService } from './daily-stock-balance.service';
import { DailyStockBalanceResolver } from './daily-stock-balance.resolver';
import { PrismaService } from 'src/prisma.service';

@Module({
  providers: [
    PrismaService,
    DailyStockBalanceResolver,
    DailyStockBalanceService,
  ],
  exports: [DailyStockBalanceService],
})
export class DailyStockBalanceModule {}
