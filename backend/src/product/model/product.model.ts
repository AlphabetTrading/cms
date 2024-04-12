import { Field, ObjectType } from '@nestjs/graphql';
import { ProductType } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';

@ObjectType()
export class Product extends BaseModel {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  productType?: ProductType;

  @Field(() => [ProductVariant], { nullable: true })
  ProductVariant?: ProductVariant[];
}
