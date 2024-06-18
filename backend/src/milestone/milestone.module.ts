import { Module } from '@nestjs/common';
import { MilestoneService } from './milestone.service';
import { MilestoneResolver } from './milestone.resolver';

@Module({
  providers: [MilestoneResolver, MilestoneService],
  exports: [MilestoneService],
})
export class MilestoneModule {}
