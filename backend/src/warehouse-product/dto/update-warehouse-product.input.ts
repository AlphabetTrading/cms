import { IsPositive } from 'class-validator';
import { CreateWarehouseProductInput } from './create-warehouse-product.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateWarehouseProductInput extends PartialType(
  CreateWarehouseProductInput,
) {
  @Field({ nullable: true })
  projectId?: string;

  @Field({ nullable: true })
  productVariantId?: string;

  @Field({ nullable: true })
  warehouseId?: string;

  @Field({ nullable: true })
  @IsPositive()
  quantity?: number;

  @Field({ nullable: true })
  @IsPositive()
  currentPrice?: number
}
