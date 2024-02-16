import { Test, TestingModule } from '@nestjs/testing';
import { MaterialReturnResolver } from './material-return.resolver';

describe('MaterialReturnResolver', () => {
  let resolver: MaterialReturnResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MaterialReturnResolver],
    }).compile();

    resolver = module.get<MaterialReturnResolver>(MaterialReturnResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
