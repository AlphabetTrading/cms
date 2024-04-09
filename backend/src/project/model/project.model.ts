import { Field, Float, ObjectType } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { Milestone, User } from '@prisma/client';
import { User as UserModel } from 'src/user/user.model';
import { Milestone as MilestoneModel } from 'src/milestone/model/milestone.model';

@ObjectType()
export class Project extends BaseModel {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  startDate?: Date;

  @Field({ nullable: true })
  endDate?: Date;

  @Field(() => Float, { nullable: true })
  budget?: number;

  @Field({ nullable: true })
  clientId?: string;

  @Field(() => UserModel, { nullable: true })
  client?: User;

  @Field({ nullable: true })
  projectManagerId?: string;

  @Field(() => UserModel, { nullable: true })
  projectManager?: User;

  @Field(() => [MilestoneModel], { nullable: true })
  milestones?: Milestone[];

  @Field(() => [ProjectUser], { nullable: true })
  projectUsers?: ProjectUser[];

  @Field({ nullable: true })
  status?: string;
}

@ObjectType()
export class ProjectUser extends BaseModel {
  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => String, { nullable: true })
  userId?: string;
}
