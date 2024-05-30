import { Test, TestingModule } from '@nestjs/testing';
import { DailySiteDataService } from './daily-site-data.service';

describe('DailySiteDataService', () => {
  let service: DailySiteDataService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DailySiteDataService],
    }).compile();

    service = module.get<DailySiteDataService>(DailySiteDataService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
