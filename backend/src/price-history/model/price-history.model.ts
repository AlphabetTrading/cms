import { ObjectType, Field } from '@nestjs/graphql';
import { Product } from '@prisma/client';
import { Product as ProductModel } from 'src/product/model/product.model';

@ObjectType()
export class PriceHistory {
  @Field()
  productId?: string;

  @Field(() => ProductModel)
  product?: Product;

  @Field()
  price?: number;
}
