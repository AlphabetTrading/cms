import { Module } from '@nestjs/common';
import { PriceHistoryService } from './price-history.service';
import { PriceHistoryResolver } from './price-history.resolver';

@Module({
  providers: [PriceHistoryResolver, PriceHistoryService],
})
export class PriceHistoryModule {}
