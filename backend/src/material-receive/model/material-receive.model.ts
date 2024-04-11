import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus, Project, User } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { User as UserModel } from 'src/user/user.model';
import { Project as ProjectModel } from 'src/project/model/project.model';

@ObjectType()
export class MaterialReceiveVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => ProjectModel, { nullable: true })
  project?: Project;

  @Field(() => String, { nullable: true })
  supplierName?: string;

  @Field(() => String, { nullable: true })
  invoiceId?: string;

  @Field(() => String, { nullable: true })
  materialRequestId?: string;

  @Field(() => String, { nullable: true })
  purchaseOrderId?: string;

  @Field(() => String, { nullable: true })
  purchasedById?: string;

  @Field(() => UserModel, { nullable: true })
  purchasedBy?: User;

  @Field(() => String, { nullable: true })
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
  productId?: string;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  unitCost?: number;

  @Field(() => Number, { nullable: true })
  totalCost?: number;

  @Field(() => String, { nullable: true })
  materialReceiveVoucherId?: string;
}
