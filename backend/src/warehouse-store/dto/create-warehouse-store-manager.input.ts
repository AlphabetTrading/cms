import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class CreateWarehouseStoreManagerInput {
  @Field()
  warehouseStoreId: string;

  @Field()
  storeManagerId: string;
}
