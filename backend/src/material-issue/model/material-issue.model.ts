import { Field, ID, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus, User } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { User as UserModel } from 'src/user/user.model';

@ObjectType()
export class MaterialIssueVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectDetails?: string;

  @Field(() => String)
  issuedToId?: string;

  @Field(() => UserModel)
  issuedTo?: User;

  @Field(() => [MaterialIssueItem])
  items?: MaterialIssueItem[];

  @Field(() => String, { nullable: true })
  requisitionNumber?: string;

  @Field(() => String)
  preparedById?: string;

  @Field(() => UserModel)
  preparedBy?: User;

  @Field(() => String, { nullable: true })
  receivedById?: string;

  @Field(() => UserModel, { nullable: true })
  receivedBy?: User;

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
export class MaterialIssueItem {
  @Field(() => ID)
  id?: string;

  @Field(() => String, { nullable: true })
  description?: string;

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

  @Field(() => String)
  materialIssueVoucherId: string;
}
