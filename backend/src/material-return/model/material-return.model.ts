import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { MaterialIssueVoucher } from 'src/material-issue/model/material-issue.model';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';
import { Project } from 'src/project/model/project.model';
import { User } from 'src/user/user.model';
import { WarehouseStore } from 'src/warehouse-store/model/warehouse-store.model';

@ObjectType()
export class MaterialReturnVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  Project?: Project;

  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  receivingWarehouseStoreId?: string;

  @Field(() => WarehouseStore, { nullable: true })
  receivingWarehouseStore?: WarehouseStore;

  @Field(() => [MaterialReturnItem])
  items?: MaterialReturnItem[];

  @Field(() => String, { nullable: true })
  returnedById?: string;

  @Field(() => User, { nullable: true })
  returnedBy?: User;

  @Field(() => String, { nullable: true })
  receivedById?: string;

  @Field(() => User, { nullable: true })
  receivedBy?: User;

  @Field(() => ApprovalStatus, {
    defaultValue: ApprovalStatus.PENDING,
    nullable: true,
  })
  status?: ApprovalStatus;
}

@ObjectType()
export class MaterialReturnItem extends BaseModel {
  @Field(() => String, { nullable: true })
  productVariantId?: string;

  @Field(() => ProductVariant, { nullable: true })
  productVariant?: ProductVariant;

  @Field(() => String, { nullable: true })
  issueVoucherId?: string;

  @Field(() => MaterialIssueVoucher, { nullable: true })
  issueVoucher?: MaterialIssueVoucher;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  unitCost?: number;

  @Field(() => Number, { nullable: true })
  totalCost?: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String, { nullable: true })
  materialReturnVoucherId?: string;
}
