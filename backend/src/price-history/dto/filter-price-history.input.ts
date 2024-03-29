import { Field, InputType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { FilterProductInput } from 'src/product/dto/filter-product.input';

@InputType()
export class FilterPriceHistoryInput {
  @Field({ nullable: true })
  id?: string;

  @Field({ nullable: true })
  productId?: string;

  @Field(() => FilterProductInput, { nullable: true })
  product?: Prisma.ProductWhereInput;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
