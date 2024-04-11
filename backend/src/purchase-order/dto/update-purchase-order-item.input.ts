import { Field, InputType, PartialType } from '@nestjs/graphql';
import { IsOptional, IsString } from 'class-validator';
import { CreatePurchaseOrderItemInput } from './create-purchase-order-item.input';

@InputType()
export class UpdatePurchaseOrderItemInput extends PartialType(
  CreatePurchaseOrderItemInput,
) {
  @Field(() => String, { nullable: true })
  @IsString()
  productId?: string;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  quantityRequested?: number;

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
