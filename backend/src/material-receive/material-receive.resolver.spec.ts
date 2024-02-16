import { Test, TestingModule } from '@nestjs/testing';
import { MaterialReceiveResolver } from './material-receive.resolver';

describe('MaterialReceiveResolver', () => {
  let resolver: MaterialReceiveResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MaterialReceiveResolver],
    }).compile();

    resolver = module.get<MaterialReceiveResolver>(MaterialReceiveResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
