import { Test, TestingModule } from '@nestjs/testing';
import { DailyStockBalanceService } from './daily-stock-balance.service';

describe('DailyStockBalanceService', () => {
  let service: DailyStockBalanceService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DailyStockBalanceService],
    }).compile();

    service = module.get<DailyStockBalanceService>(DailyStockBalanceService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
