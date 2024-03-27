import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus, User } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { User as UserModel } from 'src/user/user.model';

@ObjectType()
export class MaterialReceiveVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectDetails?: string;

  @Field(() => String)
  supplierName?: string;

  @Field(() => String)
  invoiceId?: string;

  @Field(() => String)
  materialRequestId?: string;

  @Field(() => String)
  purchaseOrderId?: string;

  @Field(() => String)
  purchasedById?: string;

  @Field(() => UserModel, { nullable: true })
  purchasedBy?: User;

  @Field(() => String, { nullable: true })
  receivedById?: string;

  @Field(() => UserModel, { nullable: true })
  receivedBy?: User;

  @Field(() => String)
  approvedById?: string;

  @Field(() => UserModel, { nullable: true })
  approvedBy?: User;

  @Field(() => ApprovalStatus, {
    defaultValue: ApprovalStatus.PENDING,
    nullable: true,
  })
  status?: ApprovalStatus;
}

@ObjectType()
export class MaterialReceiveItem extends BaseModel {
  @Field(() => String, { nullable: true })
  description?: string;

  @Field(() => String)
  unitOfMeasure?: string;

  @Field(() => Number)
  quantity?: number;

  @Field(() => Number)
  unitCost?: number;

  @Field(() => Number)
  totalCost?: number;

  @Field(() => String)
  materialReceiveVoucherId?: string;
}
