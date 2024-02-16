import { Field, ObjectType } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class Milestone extends BaseModel {
  @Field()
  name: string;

  @Field({ nullable: true })
  description?: string;

  @Field()
  dueDate: Date;

  @Field()
  status: string;

  @Field()
  projectId: string;
}
