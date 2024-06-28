import { Field, ObjectType, registerEnumType } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { User } from 'src/user/user.model';
import { Milestone } from 'src/milestone/model/milestone.model';
import { CompletionStatus, Priority } from '@prisma/client';

registerEnumType(Priority, {
  name: 'Priority',
});

registerEnumType(CompletionStatus, {
  name: 'CompletionStatus',
});

@ObjectType()
export class Task extends BaseModel {
  @Field(() => String, { nullable: true })
  name?: string;

  @Field(() => String, { nullable: true })
  description?: string;

  @Field(() => Date, { nullable: true })
  dueDate?: Date;

  @Field(() => CompletionStatus, { nullable: true })
  status?: CompletionStatus;

  @Field(() => Priority, { nullable: true })
  priority?: Priority;

  @Field(() => String, { nullable: true })
  assignedToId?: string;

  @Field(() => User, { nullable: true })
  assignedTo?: User;

  @Field(() => String, { nullable: true })
  milestoneId?: string;

  @Field(() => Milestone, { nullable: true })
  Milestone?: Milestone;
}
