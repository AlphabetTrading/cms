import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus, Project, User } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { User as UserModel } from 'src/user/user.model';
import { Project as ProjectModel } from 'src/project/model/project.model';

@ObjectType()
export class MaterialIssueVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => ProjectModel, { nullable: true })
  project?: Project;

  @Field(() => [MaterialIssueItem])
  items?: MaterialIssueItem[];

  @Field(() => String, { nullable: true })
  requisitionNumber?: string;

  @Field(() => String)
  preparedById?: string;

  @Field(() => UserModel)
  preparedBy?: User;

  @Field(() => String)
  approvedById?: string;

  @Field(() => UserModel)
  approvedBy?: User;

  @Field(() => ApprovalStatus, {
    defaultValue: ApprovalStatus.PENDING,
    nullable: true,
  })
  status?: ApprovalStatus;
}

@ObjectType()
export class MaterialIssueItem extends BaseModel {
  @Field(() => String, { nullable: true })
  productId?: string;

  @Field(() => String)
  unitOfMeasure?: string;

  @Field(() => Number)
  quantity?: number;

  @Field(() => Number)
  unitCost?: number;

  @Field(() => Number)
  totalCost: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String, { nullable: true })
  materialIssueVoucherId?: string;
}
