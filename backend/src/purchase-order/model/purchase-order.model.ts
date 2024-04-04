import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus, Project } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { Project as ProjectModel } from 'src/project/model/project.model';

@ObjectType()
export class PurchaseOrderVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => ProjectModel, { nullable: true })
  project?: Project;

  @Field(() => String, { nullable: true })
  supplierName?: string;

  @Field(() => String, { nullable: true })
  materialRequestId?: string;

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

  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => ApprovalStatus, {
    defaultValue: ApprovalStatus.PENDING,
    nullable: true,
  })
  status?: ApprovalStatus;
}

@ObjectType()
export class PurchaseOrderItem extends BaseModel {
  @Field(() => String, { nullable: true })
  productId?: string;

  @Field(() => String, { nullable: true })
  unitOfMeasure?: string;

  @Field(() => Number, { nullable: true })
  quantityRequested?: number;

  @Field(() => Number, { nullable: true })
  unitPrice?: number;

  @Field(() => Number, { nullable: true })
  totalPrice?: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String, { nullable: true })
  purchaseOrderId?: string;
}
