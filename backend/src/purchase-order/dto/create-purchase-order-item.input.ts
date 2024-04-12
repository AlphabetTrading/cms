import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

@InputType()
export class CreatePurchaseOrderItemInput {
  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  productVariantId: string;

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
