import { ObjectType, Field } from '@nestjs/graphql';
import { Product } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { Product as ProductModel } from 'src/product/model/product.model';

@ObjectType()
export class PriceHistory extends BaseModel {
  @Field({ nullable: true })
  productId?: string;

  @Field(() => ProductModel, { nullable: true })
  product?: Product;

  @Field({ nullable: true })
  price?: number;
}
