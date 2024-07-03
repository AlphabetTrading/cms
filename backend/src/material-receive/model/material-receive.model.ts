import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';
import { Project } from 'src/project/model/project.model';
import { PurchaseOrderVoucher } from 'src/purchase-order/model/purchase-order.model';
import { User } from 'src/user/user.model';
import { WarehouseStore } from 'src/warehouse-store/model/warehouse-store.model';

@ObjectType()
export class MaterialReceiveVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  Project?: Project;

  @Field(() => [MaterialReceiveItem], { nullable: true })
  items?: MaterialReceiveItem[];

  @Field(() => String, { nullable: true })
  purchaseOrderId?: string;

  @Field(() => PurchaseOrderVoucher, { nullable: true })
  purchaseOrder?: PurchaseOrderVoucher;

  @Field(() => String, { nullable: true })
  purchasedById?: string;

  @Field(() => User, { nullable: true })
  purchasedBy?: User;

  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => User, { nullable: true })
  approvedBy?: User;

  @Field(() => String, { nullable: true })
  warehouseStoreId?: string;

  @Field(() => WarehouseStore, { nullable: true })
  WarehouseStore?: WarehouseStore;

  @Field(() => ApprovalStatus, {
    defaultValue: ApprovalStatus.PENDING,
    nullable: true,
  })
  status?: ApprovalStatus;
}

@ObjectType()
export class MaterialReceiveItem extends BaseModel {
  @Field(() => String, { nullable: true })
  productVariantId?: string;

  @Field(() => ProductVariant, { nullable: true })
  productVariant?: ProductVariant;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  unitCost?: number;

  @Field(() => Number, { nullable: true })
  totalCost?: number;

  @Field(() => Number, { nullable: true })
  unloadingCost?: number;

  @Field(() => Number, { nullable: true })
  loadingCost?: number;

  @Field(() => Number, { nullable: true })
  transportationCost?: number;

  @Field(() => String, { nullable: true })
  materialReceiveVoucherId?: string;
}
