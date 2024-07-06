import { Module } from '@nestjs/common';
import { StatService } from './stat.service';
import { StatResolver } from './stat.resolver';

@Module({
  providers: [StatResolver, StatService],
})
export class StatModule {}
