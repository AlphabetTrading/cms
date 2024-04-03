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
  productId?: string;

  @Field(() => String)
  unitOfMeasure?: string;

  @Field(() => Number)
  quantity?: number;

  @Field(() => Number)
  unitCost?: number;

  @Field(() => Number)
  totalCost?: number;

  @Field(() => String, { nullable: true })
  materialReceiveVoucherId?: string;
}
