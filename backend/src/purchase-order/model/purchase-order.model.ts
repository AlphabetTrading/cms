import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { MaterialRequestVoucher } from 'src/material-request/model/material-request.model';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';
import { Project } from 'src/project/model/project.model';
import { User } from 'src/user/user.model';

@ObjectType()
export class PurchaseOrderVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  Project?: Project;

  @Field(() => String, { nullable: true })
  supplierName?: string;

  @Field(() => String, { nullable: true })
  materialRequestId?: string;

  @Field(() => MaterialRequestVoucher, { nullable: true })
  materialRequest?: MaterialRequestVoucher;

  @Field(() => [PurchaseOrderItem], { nullable: true })
  items?: PurchaseOrderItem[];

  @Field(() => Number, { nullable: true })
  subTotal?: number;

  @Field(() => Number, { nullable: true })
  vat?: number;

  @Field(() => Number, { nullable: true })
  grandTotal?: number;

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
export class PurchaseOrderItem extends BaseModel {
  @Field(() => String, { nullable: true })
  productVariantId?: string;

  @Field(() => ProductVariant, { nullable: true })
  productVariant?: ProductVariant;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  unitPrice?: number;

  @Field(() => Number, { nullable: true })
  totalPrice?: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String, { nullable: true })
  purchaseOrderId?: string;
}
