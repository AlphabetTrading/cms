import { Field, InputType } from '@nestjs/graphql';
import { CompletionStatus, Priority } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';

@InputType()
export class FilterTaskInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => StringFilter, { nullable: true })
  name?: StringFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  dueDate?: DateTimeFilter;

  @Field(() => [CompletionStatus], { nullable: true })
  status?: CompletionStatus[];

  @Field(() => [Priority], { nullable: true })
  priority?: Priority[];

  @Field(() => String, { nullable: true })
  milestoneId?: string;

  @Field(() => String, { nullable: true })
  assignedToId?: string;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
