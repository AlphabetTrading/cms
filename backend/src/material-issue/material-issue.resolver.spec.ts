import { Test, TestingModule } from '@nestjs/testing';
import { MaterialIssueResolver } from './material-issue.resolver';

describe('MaterialIssueResolver', () => {
  let resolver: MaterialIssueResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MaterialIssueResolver],
    }).compile();

    resolver = module.get<MaterialIssueResolver>(MaterialIssueResolver);
  });

  it('should be defined', () => {
    expect(resolver).toBeDefined();
  });
});
