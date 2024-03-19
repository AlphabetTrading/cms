import { Field, ID, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class MaterialReceiveVoucher extends BaseModel {
  @Field(() => Date)
  date: Date;

  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectDetails?: string;

  @Field(() => String)
  supplierName: string;

  @Field(() => String)
  invoiceId: string;

  @Field(() => String)
  materialRequestId: string;

  @Field(() => String)
  purchaseOrderId: string;

  @Field(() => String)
  purchasedById: string;

  @Field(() => String, { nullable: true })
  receivedById?: string;

  @Field(() => String)
  approvedById: string;

  @Field(() => ApprovalStatus, { nullable: true })
  approved?: ApprovalStatus;
}

@ObjectType()
export class MaterialReceiveItem {
  @Field(() => ID)
  id: string;

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

  @Field(() => String)
  materialReceiveVoucherId: string;
}
