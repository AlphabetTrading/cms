import { Field, InputType } from '@nestjs/graphql';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';

@InputType()
export class FilterMaterialReturnInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => DateTimeFilter, { nullable: true })
  date?: DateTimeFilter;

  @Field(() => StringFilter, { nullable: true })
  from?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  receivingStore?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  returnedById?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  receivedById?: StringFilter;

  @Field({ nullable: true })
  received?: boolean;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
