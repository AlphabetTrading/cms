import { Field, InputType } from '@nestjs/graphql';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';

@InputType()
export class FilterTaskInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => StringFilter, { nullable: true })
  name?: StringFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  startDate?: DateTimeFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  dueDate?: DateTimeFilter;

  @Field(() => StringFilter, { nullable: true })
  assignedToId?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  priority?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  milestoneId?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  status?: StringFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
