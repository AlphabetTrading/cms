import { Module } from '@nestjs/common';
import { PurchaseOrderService } from './purchase-order.service';
import { PurchaseOrderResolver } from './purchase-order.resolver';

@Module({
  providers: [PurchaseOrderService, PurchaseOrderResolver]
})
export class PurchaseOrderModule {}
