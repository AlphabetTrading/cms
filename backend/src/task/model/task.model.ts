import { Field, ObjectType } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';

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
  milestoneId?: string;
}
