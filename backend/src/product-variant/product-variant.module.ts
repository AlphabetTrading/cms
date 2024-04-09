import { Module } from '@nestjs/common';
import { ProductVariantService } from './product-variant.service';
import { ProductVariantResolver } from './product-variant.resolver';

@Module({
  providers: [ProductVariantResolver, ProductVariantService],
})
export class ProductVariantModule {}
