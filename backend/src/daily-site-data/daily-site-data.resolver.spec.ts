import { Test, TestingModule } from '@nestjs/testing';
import { DailySiteDataResolver } from './daily-site-data.resolver';
import { DailySiteDataService } from './daily-site-data.service';

describe('DailySiteDataResolver', () => {
  let resolver: DailySiteDataResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DailySiteDataResolver, DailySiteDataService],
    }).compile();

    resolver = module.get<DailySiteDataResolver>(DailySiteDataResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
