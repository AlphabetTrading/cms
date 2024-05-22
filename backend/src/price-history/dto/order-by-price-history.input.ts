import { Field, InputType, registerEnumType } from '@nestjs/graphql';
import { OrderDirection } from 'src/common/order/order-direction';
import { OrderByProductVariantInput } from 'src/product-variant/dto/order-by-product-variant.input';
import { OrderByProjectInput } from 'src/project/dto/order-by-project.input';

registerEnumType(OrderDirection, {
  name: 'OrderDirection',
  description:
    'Possible directions in which to order a list of items when provided an `orderBy` argument.',
});

@InputType()
export class OrderByPriceHistoryInput {
  @Field(() => OrderByProjectInput, { nullable: true })
  project?: OrderByProjectInput;

  @Field(() => OrderByProductVariantInput, { nullable: true })
  productVariant?: OrderByProductVariantInput;

  @Field(() => OrderDirection, { nullable: true })
  price?: OrderDirection;

  @Field(() => OrderDirection, { nullable: true })
  createdAt?: OrderDirection;

  @Field(() => OrderDirection, { nullable: true })
  updatedAt?: OrderDirection;
}
