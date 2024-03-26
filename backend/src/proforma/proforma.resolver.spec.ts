import { Test, TestingModule } from '@nestjs/testing';
import { ProformaResolver } from './proforma.resolver';
import { ProformaService } from './proforma.service';

describe('ProformaResolver', () => {
  let resolver: ProformaResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ProformaResolver, ProformaService],
    }).compile();

    resolver = module.get<ProformaResolver>(ProformaResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
