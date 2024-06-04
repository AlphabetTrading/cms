import { CreateWarehouseStoreManagerInput } from './create-warehouse-store-manager.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateWarehouseStoreManagerInput extends PartialType(
  CreateWarehouseStoreManagerInput,
) {
  @Field({ nullable: true })
  warehouseStoreId?: string;

  @Field({ nullable: true })
  storeManagerId?: string;
}
