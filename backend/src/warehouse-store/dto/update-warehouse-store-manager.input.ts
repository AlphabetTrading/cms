import { InputType, Field, PartialType } from '@nestjs/graphql';
import { CreateWarehouseStoreManagerInput } from './create-warehouse-store-manager.input';

@InputType()
export class UpdateWarehouseStoreManagerInput extends PartialType(
  CreateWarehouseStoreManagerInput,
) {
  @Field({ nullable: true })
  storeManagerId?: string;
}
