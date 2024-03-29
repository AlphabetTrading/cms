import { Test, TestingModule } from '@nestjs/testing';
import { WarehouseStoreResolver } from './warehouse-store.resolver';
import { WarehouseStoreService } from './warehouse-store.service';

describe('WarehouseStoreResolver', () => {
  let resolver: WarehouseStoreResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [WarehouseStoreResolver, WarehouseStoreService],
    }).compile();

    resolver = module.get<WarehouseStoreResolver>(WarehouseStoreResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
