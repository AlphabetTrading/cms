import { CreateWarehouseStoreInput } from './create-warehouse-store.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateWarehouseStoreInput extends PartialType(
  CreateWarehouseStoreInput,
) {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  location?: string;

  @Field({ nullable: true })
  companyId: string;
}
