import { Field, ObjectType } from '@nestjs/graphql';
import { ProductType, ProductVariant } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { ProductVariant as ProductVariantModel } from 'src/product-variant/model/product-variant.model';

@ObjectType()
export class Product extends BaseModel {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  productType?: ProductType;

  @Field(() => [ProductVariantModel], { nullable: true })
  ProductVariant?: ProductVariant[];
}
