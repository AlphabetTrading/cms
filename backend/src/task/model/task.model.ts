import { Field, ObjectType } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class Task extends BaseModel {
  @Field()
  name: string;

  @Field({ nullable: true })
  description?: string;

  @Field()
  startDate: Date;

  @Field()
  dueDate: Date;

  @Field()
  status: string;

  @Field()
  priority: string;

  @Field()
  assignedToId: string;

  @Field()
  milestoneId: string;
}
