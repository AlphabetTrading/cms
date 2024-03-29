import { Test, TestingModule } from '@nestjs/testing';
import { PriceHistoryResolver } from './price-history.resolver';
import { PriceHistoryService } from './price-history.service';

describe('PriceHistoryResolver', () => {
  let resolver: PriceHistoryResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PriceHistoryResolver, PriceHistoryService],
    }).compile();

    resolver = module.get<PriceHistoryResolver>(PriceHistoryResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
