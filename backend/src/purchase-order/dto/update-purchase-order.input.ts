import { Field, InputType } from '@nestjs/graphql';
import { IsOptional, IsString, ValidateNested } from 'class-validator';
import { UpdatePurchaseOrderItemInput } from './update-purchase-order-item.input';
import { ApprovalStatus } from '@prisma/client';

@InputType()
export class UpdatePurchaseOrderInput {
  @IsString()
  @Field(() => String)
  id: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  projectId?: string;

  @ValidateNested({ each: true })
  @Field(() => [UpdatePurchaseOrderItemInput])
  items?: UpdatePurchaseOrderItemInput[];

  @IsOptional()
  @Field(() => String, { nullable: true })
  preparedById?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => ApprovalStatus, { nullable: true })
  status?: ApprovalStatus;
}
