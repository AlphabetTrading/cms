import { Module } from '@nestjs/common';
import { DailySiteDataService } from './daily-site-data.service';
import { DailySiteDataResolver } from './daily-site-data.resolver';

@Module({
  providers: [DailySiteDataResolver, DailySiteDataService],
})
export class DailySiteDataModule {}
