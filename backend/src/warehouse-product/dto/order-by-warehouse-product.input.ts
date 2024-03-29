import { Field, InputType, registerEnumType } from '@nestjs/graphql';
import { OrderDirection } from 'src/common/order/order-direction';
import { OrderByProductInput } from 'src/product/dto/order-by-product.input';
import { OrderByWarehouseStoreInput } from 'src/warehouse-store/dto/order-by-warehouse-store.input';

registerEnumType(OrderDirection, {
  name: 'OrderDirection',
  description:
    'Possible directions in which to order a list of items when provided an `orderBy` argument.',
});

@InputType()
export class OrderByWarehouseProductInput {
  @Field(() => OrderByProductInput, { nullable: true })
  product?: OrderByProductInput;

  @Field(() => OrderByWarehouseStoreInput, { nullable: true })
  warehouse?: OrderByWarehouseStoreInput;

  @Field(() => OrderDirection, { nullable: true })
  quantity?: OrderDirection;

  @Field(() => OrderDirection, { nullable: true })
  createdAt?: OrderDirection;

  @Field(() => OrderDirection, { nullable: true })
  updatedAt?: OrderDirection;
}
