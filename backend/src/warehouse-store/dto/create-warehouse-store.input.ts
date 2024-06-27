import { InputType, Field } from '@nestjs/graphql';
import { ValidateNested } from 'class-validator';
import { CreateWarehouseStoreManagerInput } from './create-warehouse-store-manager.input';

@InputType()
export class CreateWarehouseStoreInput {
  @Field()
  name: string;

  @Field()
  location: string;

  @Field()
  companyId: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateWarehouseStoreManagerInput], { nullable: true })
  warehouseStoreManagerIds?: CreateWarehouseStoreManagerInput[];
}
