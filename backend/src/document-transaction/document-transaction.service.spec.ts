import { Test, TestingModule } from '@nestjs/testing';
import { DocumentTransactionService } from './document-transaction.service';

describe('DocumentTransactionService', () => {
  let service: DocumentTransactionService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DocumentTransactionService],
    }).compile();

    service = module.get<DocumentTransactionService>(DocumentTransactionService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
