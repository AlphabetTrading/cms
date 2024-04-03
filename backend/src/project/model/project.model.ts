import { Field, Float, ObjectType } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class Project extends BaseModel {
  @Field()
  name: string;

  @Field()
  startDate: Date;

  @Field({ nullable: true })
  endDate?: Date;

  @Field(() => Float)
  budget: number;

  @Field()
  clientId: string;

  @Field()
  projectManagerId: string;

  @Field(() => [ProjectUser])
  projectUsers?: ProjectUser[];

  @Field()
  status: string;
}

@ObjectType()
export class ProjectUser extends BaseModel {
  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => String, { nullable: true })
  userId?: string;
}
