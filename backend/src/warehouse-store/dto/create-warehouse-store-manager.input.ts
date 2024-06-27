import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class CreateWarehouseStoreManagerInput {
  @Field()
  storeManagerId: string;
}
