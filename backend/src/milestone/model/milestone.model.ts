import { Field, ObjectType } from '@nestjs/graphql';
import { UseType } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { Project } from 'src/project/model/project.model';
import { Task } from 'src/task/model/task.model';
import { User } from 'src/user/user.model';

@ObjectType()
export class Milestone extends BaseModel {
  @Field(() => String, { nullable: true })
  name?: string;

  @Field(() => UseType, { nullable: true })
  stage?: UseType;

  @Field(() => String, { nullable: true })
  description?: string;

  @Field(() => Date, { nullable: true })
  dueDate?: Date;

  @Field(() => Number, { nullable: true })
  progress?: number;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  Project?: Project;

  @Field(() => String, { nullable: true })
  createdById?: string;

  @Field(() => User, { nullable: true })
  createdBy?: User;

  @Field(() => [Task], { nullable: true })
  Tasks?: Task[];
}
