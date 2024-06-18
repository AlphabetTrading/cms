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
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  description?: string;

  @Field({ nullable: true })
  dueDate?: Date;

  @Field({ nullable: true })
  status?: CompletionStatus;

  @Field({ nullable: true })
  priority?: Priority;

  @Field({ nullable: true })
  assignedToId?: string;

  @Field(() => User, { nullable: true })
  assignedTo?: User;

  @Field({ nullable: true })
  milestoneId?: string;

  @Field(() => Milestone, { nullable: true })
  Milestone?: Milestone;
}
