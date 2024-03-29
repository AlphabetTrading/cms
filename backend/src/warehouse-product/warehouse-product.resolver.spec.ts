import { Test, TestingModule } from '@nestjs/testing';
import { WarehouseProductResolver } from './warehouse-product.resolver';
import { WarehouseProductService } from './warehouse-product.service';

describe('WarehouseProductResolver', () => {
  let resolver: WarehouseProductResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [WarehouseProductResolver, WarehouseProductService],
    }).compile();

    resolver = module.get<WarehouseProductResolver>(WarehouseProductResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
