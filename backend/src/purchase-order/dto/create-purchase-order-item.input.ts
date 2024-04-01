import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional } from 'class-validator';

@InputType()
export class CreatePurchaseOrderItemInput {
  @IsOptional()
  @Field(() => String)
  description: string;

  @IsNotEmpty()
  @Field(() => String)
  unitOfMeasure: string;

  @IsNotEmpty()
  @Field(() => Number)
  quantity: number;

  @IsNotEmpty()
  @Field(() => Number)
  unitPrice: number;

  @IsNotEmpty()
  @Field(() => Number)
  totalPrice: number;

  @IsOptional()
  @Field(() => String, { nullable: true })
  remark?: string;

  @IsNotEmpty()
  @Field(() => String)
  purchaseOrderId: string;
}
