import { Field, InputType, PartialType } from '@nestjs/graphql';
import { IsOptional } from 'class-validator';
import { CreatePurchaseOrderItemInput } from './create-purchase-order-item.input';

@InputType()
export class UpdatePurchaseOrderItemInput extends PartialType(
  CreatePurchaseOrderItemInput,
) {
  @Field(() => String, { nullable: true })
  @IsOptional()
  materialRequestItemId?: string;

  @Field(() => String, { nullable: true })
  @IsOptional()
  proformaId?: string;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  quantity?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  unitPrice?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  totalPrice?: number;

  @IsOptional()
  @Field(() => String, { nullable: true })
  remark?: string;
}
