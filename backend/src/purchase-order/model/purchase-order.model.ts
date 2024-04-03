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
  @Field(() => String)
  productId?: string;

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

  @Field(() => String, { nullable: true })
  purchaseOrderId?: string;
}
