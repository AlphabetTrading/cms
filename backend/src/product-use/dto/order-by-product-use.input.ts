import { Field, InputType, registerEnumType } from '@nestjs/graphql';
import { OrderDirection } from 'src/common/order/order-direction';

registerEnumType(OrderDirection, {
  name: 'OrderDirection',
  description:
    'Possible directions in which to order a list of items when provided an `orderBy` argument.',
});

@InputType()
export class OrderByProductUseInput {
  @Field(() => OrderDirection, { nullable: true })
  productVariantId?: OrderDirection;

  @Field(() => OrderDirection, { nullable: true })
  createdAt?: OrderDirection;

  @Field(() => OrderDirection, { nullable: true })
  updatedAt?: OrderDirection;
}
