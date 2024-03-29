import { Test, TestingModule } from '@nestjs/testing';
import { WarehouseProductService } from './warehouse-product.service';

describe('WarehouseProductService', () => {
  let service: WarehouseProductService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [WarehouseProductService],
    }).compile();

    service = module.get<WarehouseProductService>(WarehouseProductService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
