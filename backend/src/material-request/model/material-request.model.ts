import { Field, ID, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class MaterialRequestVoucher extends BaseModel {
  @Field(() => Date)
  date: Date;

  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String)
  from: string;

  @Field(() => String)
  to: string;

  @Field(() => [MaterialRequestItem])
  items: MaterialRequestItem[];

  @Field(() => String)
  requestedById: string;

  @Field(() => String)
  approvedById: string;

  @Field(() => ApprovalStatus, { nullable: true })
  approved?: ApprovalStatus;
}

@ObjectType()
export class MaterialRequestItem {
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

  @Field(() => Number, { nullable: true })
  inStockQuantity?: number;

  @Field(() => Number, { nullable: true })
  toBePurchasedQuantity?: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String)
  materialRequestVoucherId: string;
}
