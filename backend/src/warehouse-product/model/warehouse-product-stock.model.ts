import { ObjectType, Field } from '@nestjs/graphql';
import { ProductVariant } from '@prisma/client';
import { ProductVariant as ProductVariantModel } from 'src/product-variant/model/product-variant.model';

@ObjectType()
export class WarehouseProductStock {
  @Field({ nullable: true })
  productId?: string;

  @Field(() => ProductVariantModel, { nullable: true })
  productVariant?: ProductVariant;

  @Field(() => Number, { nullable: true })
  quantity?: number;
}
