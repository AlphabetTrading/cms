import { InputType, Field } from '@nestjs/graphql';
import { UpdateWarehouseStoreManagerInput } from './update-warehouse-store-manager.input';
import { ValidateNested } from 'class-validator';

@InputType()
export class UpdateWarehouseStoreInput {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  location?: string;

  @Field({ nullable: true })
  companyId?: string;

  @ValidateNested({ each: true })
  @Field(() => [UpdateWarehouseStoreManagerInput], { nullable: true })
  warehouseStoreManagerIds?: UpdateWarehouseStoreManagerInput[];

}
