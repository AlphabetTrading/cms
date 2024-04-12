import { ObjectType, Field } from '@nestjs/graphql';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';

@ObjectType()
export class WarehouseProductStock {
  @Field({ nullable: true })
  productVariant?: ProductVariant;

  @Field(() => Number, { nullable: true })
  quantity?: number;
}
