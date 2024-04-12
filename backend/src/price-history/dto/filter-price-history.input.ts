import { Field, InputType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { FilterProductVariantInput } from 'src/product-variant/dto/filter-product-variant.input';

@InputType()
export class FilterPriceHistoryInput {
  @Field({ nullable: true })
  id?: string;

  @Field({ nullable: true })
  productId?: string;

  @Field(() => FilterProductVariantInput, { nullable: true })
  productVariant?: Prisma.ProductVariantWhereInput;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
