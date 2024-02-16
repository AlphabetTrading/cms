import { Test, TestingModule } from '@nestjs/testing';
import { MaterialIssueService } from './material-issue.service';

describe('MaterialIssueService', () => {
  let service: MaterialIssueService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MaterialIssueService],
    }).compile();

    service = module.get<MaterialIssueService>(MaterialIssueService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
