import { Field, InputType, PartialType } from '@nestjs/graphql';
import { IsOptional } from 'class-validator';
import { CreatePurchaseOrderItemInput } from './create-purchase-order-item.input';

@InputType()
export class UpdatePurchaseOrderItemInput extends PartialType(
  CreatePurchaseOrderItemInput,
) {
  @IsOptional()
  @Field(() => Number, { nullable: true })
  listNo?: number;

  @IsOptional()
  @Field(() => String, { nullable: true })
  description?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  unitOfMeasure?: string;

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

  @IsOptional()
  @Field(() => String, { nullable: true })
  purchaseOrderId?: string;
}
