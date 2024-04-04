import { ObjectType, Field } from '@nestjs/graphql';
import { Product } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { Product as ProductModel } from 'src/product/model/product.model';

@ObjectType()
export class PriceHistory extends BaseModel {
  @Field()
  productId?: string;

  @Field(() => ProductModel)
  product?: Product;

  @Field()
  price?: number;
}
