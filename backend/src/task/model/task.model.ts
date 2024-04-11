import { Field, ObjectType } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { User } from 'src/user/user.model';
import { Milestone } from 'src/milestone/model/milestone.model';
@ObjectType()
export class Task extends BaseModel {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  description?: string;

  @Field({ nullable: true })
  startDate?: Date;

  @Field({ nullable: true })
  dueDate?: Date;

  @Field({ nullable: true })
  status?: string;

  @Field({ nullable: true })
  priority?: string;

  @Field({ nullable: true })
  assignedToId?: string;

  @Field({ nullable: true })
  assignedTo?: User;

  @Field({ nullable: true })
  milestoneId?: string;

  @Field({ nullable: true })
  Milestone?: Milestone;
}
