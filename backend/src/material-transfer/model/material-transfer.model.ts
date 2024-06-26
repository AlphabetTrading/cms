import { ObjectType, Field } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { MaterialReceiveVoucher } from 'src/material-receive/model/material-receive.model';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';
import { Project } from 'src/project/model/project.model';
import { User } from 'src/user/user.model';
import { WarehouseStore } from 'src/warehouse-store/model/warehouse-store.model';

@ObjectType()
export class MaterialTransferVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  Project?: Project;

  @Field(() => String, { nullable: true })
  materialGroup?: string;

  @Field(() => String, { nullable: true })
  receivingWarehouseStoreId?: string;

  @Field(() => WarehouseStore, { nullable: true })
  receivingWarehouseStore?: WarehouseStore;

  @Field(() => String, { nullable: true })
  sendingWarehouseStoreId?: string;

  @Field(() => WarehouseStore, { nullable: true })
  sendingWarehouseStore?: WarehouseStore;

  @Field(() => String, { nullable: true })
  sendingStore?: string;

  @Field(() => String, { nullable: true })
  vehiclePlateNo?: string;

  @Field(() => String, { nullable: true })
  sentThroughName?: string;

  @Field(() => [MaterialTransferItem], { nullable: true })
  items?: MaterialTransferItem[];

  @Field(() => String, { nullable: true })
  requisitionNumber?: string;

  @Field(() => String, { nullable: true })
  materialReceiveId?: string;

  @Field(() => MaterialReceiveVoucher, { nullable: true })
  materialReceive?: MaterialReceiveVoucher;

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
export class MaterialTransferItem extends BaseModel {
  @Field(() => String, { nullable: true })
  productVariantId?: string;

  @Field(() => ProductVariant, { nullable: true })
  productVariant?: ProductVariant;

  @Field(() => Number, { nullable: true })
  quantityRequested?: number;

  @Field(() => Number, { nullable: true })
  quantityTransferred?: number;

  @Field(() => Number, { nullable: true })
  unitCost?: number;

  @Field(() => Number, { nullable: true })
  totalCost?: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String, { nullable: true })
  materialTransferVoucherId?: string;
}
