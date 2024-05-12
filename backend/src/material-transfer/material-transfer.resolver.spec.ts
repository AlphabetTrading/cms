import { Test, TestingModule } from '@nestjs/testing';
import { MaterialTransferResolver } from './material-transfer.resolver';
import { MaterialTransferService } from './material-transfer.service';

describe('MaterialTransferResolver', () => {
  let resolver: MaterialTransferResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MaterialTransferResolver, MaterialTransferService],
    }).compile();

    resolver = module.get<MaterialTransferResolver>(MaterialTransferResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
