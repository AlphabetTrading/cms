import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { Project } from 'src/project/model/project.model';
import { User } from 'src/user/user.model';
import { DailySiteDataTask } from './daily-site-data-task.model';
import { ApprovalStatus } from '@prisma/client';

@ObjectType()
export class DailySiteData extends BaseModel {
  @Field(() => Date, { nullable: true })
  date?: Date;
  
  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  Project?: Project;

  @Field(() => String, { nullable: true })
  contractor?: string;

  @Field(() => [DailySiteDataTask], { nullable: true })
  tasks?: DailySiteDataTask[];

  @Field(() => String, { nullable: true })
  preparedById?: string;

  @Field(() => User, { nullable: true })
  preparedBy?: User;

  @Field(() => String, { nullable: true })
  checkedById?: string;

  @Field(() => User, { nullable: true })
  checkedBy?: User;

  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => User, { nullable: true })
  approvedBy?: User;

  @Field(() => ApprovalStatus, {
    defaultValue: ApprovalStatus.PENDING,
    nullable: true,
  })
  status?: ApprovalStatus;

}
