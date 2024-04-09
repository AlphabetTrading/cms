import { Field, InputType } from '@nestjs/graphql';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';

@InputType()
export class FilterProductVariantInput {
  @Field({ nullable: true })
  id?: string;

  @Field({ nullable: true })
  productId?: string;

  @Field(() => StringFilter, { nullable: true })
  variant?: StringFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
