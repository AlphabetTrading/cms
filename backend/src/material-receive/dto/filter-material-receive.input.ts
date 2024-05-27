import { Field, InputType, registerEnumType } from '@nestjs/graphql';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';
import { FilterMaterialRequestInput } from 'src/material-request/dto/filter-material-request.input';
import { FilterProjectInput } from 'src/project/dto/filter-project.input';
import { FilterPurchaseOrderInput } from 'src/purchase-order/dto/filter-purchase-order.input';
import { FilterUserDocumentsInput } from 'src/user/dto/filter-user-documents.input';

registerEnumType(ApprovalStatus, {
  name: 'ApprovalStatus',
  description: 'Possible options for Approval Status',
});

@InputType()
export class FilterMaterialReceiveInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => StringFilter, { nullable: true })
  serialNumber?: StringFilter;

  @Field({ nullable: true })
  projectId?: string;

  @Field(() => FilterProjectInput, { nullable: true })
  project?: Prisma.ProjectWhereInput;

  @Field(() => StringFilter, { nullable: true })
  supplierName?: StringFilter;

  @Field(() => String, { nullable: true })
  materialRequestId?: string;

  @Field(() => FilterMaterialRequestInput, { nullable: true })
  materialRequest?: Prisma.MaterialRequestVoucherWhereInput;

  @Field(() => StringFilter, { nullable: true })
  invoiceId?: StringFilter;

  @Field(() => String, { nullable: true })
  purchasedById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  purchasedBy?: Prisma.UserWhereInput;

  @Field(() => String, { nullable: true })
  purchaseOrderId?: string;

  @Field(() => FilterPurchaseOrderInput, { nullable: true })
  purchaseOrder?: Prisma.PurchaseOrderWhereInput;

  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  approvedBy?: Prisma.UserWhereInput;

  @Field(() => [ApprovalStatus], { nullable: true })
  status?: ApprovalStatus[];

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
