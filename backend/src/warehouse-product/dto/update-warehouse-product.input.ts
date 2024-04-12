import { CreateWarehouseProductInput } from './create-warehouse-product.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateWarehouseProductInput extends PartialType(
  CreateWarehouseProductInput,
) {
  @Field({ nullable: true })
  productVariantId?: string;

  @Field({ nullable: true })
  warehouseId?: string;

  @Field({ nullable: true })
  quantity?: number;
}
