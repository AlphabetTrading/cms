import { InputType, Field } from '@nestjs/graphql';
import { IsPositive } from 'class-validator';

@InputType()
export class CreateWarehouseProductInput {
  @Field()
  projectId: string;

  @Field()
  warehouseId: string;

  @Field()
  productVariantId: string;

  @Field()
  @IsPositive()
  quantity: number;

  @Field()
  @IsPositive()
  currentPrice: number;
}