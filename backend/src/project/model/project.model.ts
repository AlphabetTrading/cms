import { Field, Float, ObjectType } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { Company } from 'src/company/model/company.model';
import { Milestone } from 'src/milestone/model/milestone.model';
import { User } from 'src/user/user.model';

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
  companyId?: string;

  @Field(() => Company, { nullable: true })
  company?: Company;

  @Field(() => [Milestone], { nullable: true })
  Milestones?: Milestone[];

  @Field(() => [ProjectUser], { nullable: true })
  ProjectUsers?: ProjectUser[];

  @Field({ nullable: true })
  status?: string;
}

@ObjectType()
export class ProjectUser extends BaseModel {
  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  project?: Project;

  @Field(() => String, { nullable: true })
  userId?: string;

  @Field(() => User, { nullable: true })
  user?: User;
}
