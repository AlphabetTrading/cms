import { Field, ObjectType, registerEnumType } from '@nestjs/graphql';
import {
  ApprovalStatus,
  SubStructureUseDescription,
  SuperStructureUseDescription,
  UseType,
} from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';
import { Project } from 'src/project/model/project.model';
import { User } from 'src/user/user.model';
import { WarehouseStore } from 'src/warehouse-store/model/warehouse-store.model';

registerEnumType(UseType, {
  name: 'UseType',
});

registerEnumType(SuperStructureUseDescription, {
  name: 'SuperStructureUseDescription',
});

registerEnumType(SubStructureUseDescription, {
  name: 'SubStructureUseDescription',
});

@ObjectType()
export class MaterialIssueVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  project?: Project;

  @Field(() => String, { nullable: true })
  warehouseStoreId?: string;

  @Field(() => WarehouseStore, { nullable: true })
  warehouseStore?: WarehouseStore;

  @Field(() => [MaterialIssueItem], { nullable: true })
  items?: MaterialIssueItem[];

  @Field(() => String, { nullable: true })
  requisitionNumber?: string;

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
export class MaterialIssueItem extends BaseModel {
  @Field(() => String, { nullable: true })
  productVariantId?: string;

  @Field(() => ProductVariant, { nullable: true })
  productVariant?: ProductVariant;

  @Field(() => UseType, { nullable: true })
  useType?: UseType;

  @Field(() => SubStructureUseDescription, { nullable: true })
  subStructureDescription?: SubStructureUseDescription;

  @Field(() => SuperStructureUseDescription, { nullable: true })
  superStructureDescription?: SuperStructureUseDescription;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  unitCost?: number;

  @Field(() => Number, { nullable: true })
  totalCost: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String, { nullable: true })
  materialIssueVoucherId?: string;
}
