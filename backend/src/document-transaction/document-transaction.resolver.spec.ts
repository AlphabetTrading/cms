import { Test, TestingModule } from '@nestjs/testing';
import { DocumentTransactionResolver } from './document-transaction.resolver';
import { DocumentTransactionService } from './document-transaction.service';

describe('DocumentTransactionResolver', () => {
  let resolver: DocumentTransactionResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DocumentTransactionResolver, DocumentTransactionService],
    }).compile();

    resolver = module.get<DocumentTransactionResolver>(DocumentTransactionResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
