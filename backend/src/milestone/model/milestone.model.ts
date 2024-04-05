import { Field, ObjectType } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class Milestone extends BaseModel {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  description?: string;

  @Field({ nullable: true })
  dueDate?: Date;

  @Field({ nullable: true })
  status?: string;

  @Field({ nullable: true })
  projectId?: string;
}
