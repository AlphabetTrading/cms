import { Field, InputType } from '@nestjs/graphql';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { NumberFilter } from 'src/common/filter/number-filter';
import { StringFilter } from 'src/common/filter/string-filter';

@InputType()
export class FilterProjectInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => StringFilter, { nullable: true })
  name?: StringFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  startDate?: DateTimeFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  endDate?: DateTimeFilter;

  @Field(() => NumberFilter, { nullable: true })
  budget?: NumberFilter;

  @Field(() => StringFilter, { nullable: true })
  clientId?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  projectManagerId?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  status?: StringFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
