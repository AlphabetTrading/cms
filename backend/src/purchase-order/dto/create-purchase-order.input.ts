import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional, ValidateNested } from 'class-validator';
import { CreatePurchaseOrderItemInput } from './create-purchase-order-item.input';

@InputType()
export class CreatePurchaseOrderInput {
  @IsNotEmpty()
  @Field(() => String)
  projectId: string;

  @ValidateNested({ each: true })
  @Field(() => [CreatePurchaseOrderItemInput])
  items: CreatePurchaseOrderItemInput[];

  @IsNotEmpty()
  @Field(() => String)
  preparedById: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;
}
