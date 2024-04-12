import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { ProductUse } from 'src/product-use/model/product-use.model';
import { Project } from 'src/project/model/project.model';
import { User } from 'src/user/user.model';

@ObjectType()
export class MaterialIssueVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  project?: Project;

  @Field(() => [MaterialIssueItem], { nullable: true })
  items?: MaterialIssueItem[];

  @Field(() => String, { nullable: true })
  requisitionNumber?: string;

  @Field(() => String, { nullable: true })
  preparedById?: string;

  @Field(() => User, { nullable: true })
  preparedBy?: User;

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

@ObjectType()
export class MaterialIssueItem extends BaseModel {
  @Field(() => String, { nullable: true })
  productUseId?: string;

  @Field(() => ProductUse, { nullable: true })
  productUse?: ProductUse;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  unitCost?: number;

  @Field(() => Number, { nullable: true })
  totalCost: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String, { nullable: true })
  materialIssueVoucherId?: string;
}
