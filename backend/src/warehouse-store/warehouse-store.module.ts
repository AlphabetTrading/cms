import { Module } from '@nestjs/common';
import { WarehouseStoreService } from './warehouse-store.service';
import { WarehouseStoreResolver } from './warehouse-store.resolver';

@Module({
  providers: [WarehouseStoreResolver, WarehouseStoreService],
})
export class WarehouseStoreModule {}
