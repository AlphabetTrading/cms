import { Test, TestingModule } from '@nestjs/testing';
import { DailyStockBalanceResolver } from './daily-stock-balance.resolver';
import { DailyStockBalanceService } from './daily-stock-balance.service';

describe('DailyStockBalanceResolver', () => {
  let resolver: DailyStockBalanceResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DailyStockBalanceResolver, DailyStockBalanceService],
    }).compile();

    resolver = module.get<DailyStockBalanceResolver>(DailyStockBalanceResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
