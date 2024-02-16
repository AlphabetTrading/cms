import { Module } from '@nestjs/common';
import { MaterialIssueService } from './material-issue.service';
import { MaterialIssueResolver } from './material-issue.resolver';

@Module({
  providers: [MaterialIssueService, MaterialIssueResolver],
  exports: [MaterialIssueService],
})
export class MaterialIssueModule {}
