import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional, ValidateNested } from 'class-validator';
import { CreatePurchaseOrderItemInput } from './create-purchase-order-item.input';

@InputType()
export class CreatePurchaseOrderInput {
  @IsNotEmpty()
  @Field(() => String)
  projectId: string;

  @IsNotEmpty()
  @Field(() => String)
  supplierName: string;

  @IsNotEmpty()
  @Field(() => String)
  materialRequestId: string;

  @ValidateNested({ each: true })
  @Field(() => [CreatePurchaseOrderItemInput])
  items: CreatePurchaseOrderItemInput[];

  @IsNotEmpty()
  @Field(() => Number)
  subTotal: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  vat?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  grandTotal?: number;

  @IsNotEmpty()
  @Field(() => String)
  preparedById: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;
}
