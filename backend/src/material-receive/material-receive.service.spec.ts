import { Test, TestingModule } from '@nestjs/testing';
import { MaterialReceiveService } from './material-receive.service';

describe('MaterialReceiveService', () => {
  let service: MaterialReceiveService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MaterialReceiveService],
    }).compile();

    service = module.get<MaterialReceiveService>(MaterialReceiveService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
