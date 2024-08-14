import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { MaterialTransferVoucher } from 'src/material-transfer/model/material-transfer.model';
import { Project } from 'src/project/model/project.model';
import { PurchaseOrderItem } from 'src/purchase-order/model/purchase-order.model';
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
  preparedById?: string;

  @Field(() => User, { nullable: true })
  preparedBy?: User;

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

  @Field(() => [MaterialTransferVoucher], { nullable: true })
  MaterialTransferVoucher?: MaterialTransferVoucher[];
}

@ObjectType()
export class MaterialReceiveItem extends BaseModel {
  @Field(() => String, { nullable: true })
  purchaseOrderItemId?: string;

  @Field(() => PurchaseOrderItem, { nullable: true })
  purchaseOrderItem?: PurchaseOrderItem;

  @Field(() => Number, { nullable: true })
  receivedQuantity?: number;

  @Field(() => Number, { nullable: true })
  unloadingCost?: number;

  @Field(() => Number, { nullable: true })
  loadingCost?: number;

  @Field(() => Number, { nullable: true })
  transportationCost?: number;

  @Field(() => String, { nullable: true })
  materialReceiveVoucherId?: string;

  @Field(() => MaterialReceiveVoucher, { nullable: true })
  materialReceiveVoucher?: MaterialReceiveVoucher;
}
