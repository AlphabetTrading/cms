import { Test, TestingModule } from '@nestjs/testing';
import { ProductUseResolver } from './product-use.resolver';
import { ProductUseService } from './product-use.service';

describe('ProductUseResolver', () => {
  let resolver: ProductUseResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ProductUseResolver, ProductUseService],
    }).compile();

    resolver = module.get<ProductUseResolver>(ProductUseResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
