import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class PurchaseOrderVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => Date, { nullable: true })
  dateOfReceiving?: Date;

  @Field(() => String)
  purchaseNumber?: string;

  @Field(() => String, { nullable: true })
  projectDetails?: string;

  @Field(() => String)
  supplierName?: string;

  @Field(() => String)
  materialRequestId?: string;

  @Field(() => [PurchaseOrderItem])
  items?: PurchaseOrderItem[];

  @Field(() => Number)
  subTotal?: number;

  @Field(() => Number, { nullable: true })
  vat?: number;

  @Field(() => Number, { nullable: true })
  grandTotal?: number;

  @Field(() => String)
  preparedById?: string;

  @Field(() => String)
  approvedById?: string;

  @Field(() => ApprovalStatus, {
    defaultValue: ApprovalStatus.PENDING,
    nullable: true,
  })
  status?: ApprovalStatus;
}

@ObjectType()
export class PurchaseOrderItem extends BaseModel {
  @Field(() => Number)
  listNo?: number;

  @Field(() => String, { nullable: true })
  description?: string;

  @Field(() => String)
  unitOfMeasure?: string;

  @Field(() => Number)
  quantityRequested?: number;

  @Field(() => Number)
  unitPrice?: number;

  @Field(() => Number)
  totalPrice?: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String)
  purchaseOrderId?: string;
}
