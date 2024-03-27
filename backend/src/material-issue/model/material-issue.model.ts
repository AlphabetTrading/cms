import { Field, ID, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class MaterialIssueVoucher extends BaseModel {
  @Field(() => Date)
  date: Date;

  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectDetails?: string;

  @Field(() => String)
  issuedToId: string;

  @Field(() => [MaterialIssueItem])
  items: MaterialIssueItem[];

  @Field(() => String, { nullable: true })
  requisitionNumber?: string;

  @Field(() => String)
  preparedById: string;

  @Field(() => String, { nullable: true })
  receivedById?: string;

  @Field(() => String)
  approvedById: string;

  @Field(() => ApprovalStatus, {
    defaultValue: ApprovalStatus.PENDING,
    nullable: true,
  })
  approved?: ApprovalStatus;
}

@ObjectType()
export class MaterialIssueItem {
  @Field(() => ID)
  id: string;

  @Field(() => Number)
  listNo: number;

  @Field(() => String, { nullable: true })
  description?: string;

  @Field(() => String)
  unitOfMeasure: string;

  @Field(() => Number)
  quantity: number;

  @Field(() => Number)
  unitCost: number;

  @Field(() => Number)
  totalCost: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String)
  materialIssueVoucherId: string;
}
