import { Test, TestingModule } from '@nestjs/testing';
import { MaterialRequestResolver } from './material-request.resolver';

describe('MaterialRequestResolver', () => {
  let resolver: MaterialRequestResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MaterialRequestResolver],
    }).compile();

    resolver = module.get<MaterialRequestResolver>(MaterialRequestResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
