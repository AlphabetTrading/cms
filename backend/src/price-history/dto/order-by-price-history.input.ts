import { Field, InputType, registerEnumType } from '@nestjs/graphql';
import { OrderDirection } from 'src/common/order/order-direction';
import { OrderByProductInput } from 'src/product/dto/order-by-product.input';

registerEnumType(OrderDirection, {
  name: 'OrderDirection',
  description:
    'Possible directions in which to order a list of items when provided an `orderBy` argument.',
});

@InputType()
export class OrderByPriceHistoryInput {
  @Field(() => OrderByProductInput, { nullable: true })
  product?: OrderByProductInput;

  @Field(() => OrderDirection, { nullable: true })
  price?: OrderDirection;

  @Field(() => OrderDirection, { nullable: true })
  createdAt?: OrderDirection;

  @Field(() => OrderDirection, { nullable: true })
  updatedAt?: OrderDirection;
}
