import { Test, TestingModule } from '@nestjs/testing';
import { MaterialTransferService } from './material-transfer.service';

describe('MaterialTransferService', () => {
  let service: MaterialTransferService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MaterialTransferService],
    }).compile();

    service = module.get<MaterialTransferService>(MaterialTransferService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
