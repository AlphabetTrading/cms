import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { User } from 'src/user/user.model';
import { WarehouseStore } from './warehouse-store.model';

@ObjectType()
export class WarehouseStoreManager extends BaseModel {
  @Field({ nullable: true })
  warehouseStoreId?: string;

  @Field(() => WarehouseStore, { nullable: true })
  WarehouseStore?: WarehouseStore;

  @Field({ nullable: true })
  storeManagerId?: string;

  @Field(() => User, { nullable: true })
  StoreManager?: User;
}
