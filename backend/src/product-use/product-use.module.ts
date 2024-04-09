import { Module } from '@nestjs/common';
import { ProductUseService } from './product-use.service';
import { ProductUseResolver } from './product-use.resolver';

@Module({
  providers: [ProductUseResolver, ProductUseService],
})
export class ProductUseModule {}
