import { ObjectType, Field } from '@nestjs/graphql';
import { ProductVariant } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { ProductVariant as ProductVariantModel } from 'src/product-variant/model/product-variant.model';

@ObjectType()
export class PriceHistory extends BaseModel {
  @Field({ nullable: true })
  productId?: string;

  @Field(() => ProductVariantModel, { nullable: true })
  productVariant?: ProductVariant;

  @Field({ nullable: true })
  price?: number;
}
