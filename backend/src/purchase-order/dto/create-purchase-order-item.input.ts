import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional } from 'class-validator';

@InputType()
export class CreatePurchaseOrderItemInput {
  @Field(() => String, { nullable: true })
  @IsOptional()
  materialRequestItemId?: string;

  @Field(() => String, { nullable: true })
  @IsOptional()
  proformaId?: string;

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
}
