import { Module } from '@nestjs/common';
import { WarehouseProductService } from './warehouse-product.service';
import { WarehouseProductResolver } from './warehouse-product.resolver';

@Module({
  providers: [WarehouseProductResolver, WarehouseProductService],
})
export class WarehouseProductModule {}
