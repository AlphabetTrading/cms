import { Test, TestingModule } from '@nestjs/testing';
import { ProductUseService } from './product-use.service';

describe('ProductUseService', () => {
  let service: ProductUseService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ProductUseService],
    }).compile();

    service = module.get<ProductUseService>(ProductUseService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
