import { Test, TestingModule } from '@nestjs/testing';
import { WarehouseStoreService } from './warehouse-store.service';

describe('WarehouseStoreService', () => {
  let service: WarehouseStoreService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [WarehouseStoreService],
    }).compile();

    service = module.get<WarehouseStoreService>(WarehouseStoreService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
