import { Field, InputType } from '@nestjs/graphql';
import { IsBoolean, IsOptional, ValidateNested } from 'class-validator';
import { UpdatePurchaseOrderItemInput } from './update-purchase-order-item.input';

@InputType()
export class UpdatePurchaseOrderInput {
  @IsOptional()
  @Field(() => Date, { nullable: true })
  date?: Date;

  @IsOptional()
  @Field(() => Date, { nullable: true })
  dateOfReceiving?: Date;

  @IsOptional()
  @Field(() => String, { nullable: true })
  purchaseNumber?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  projectDetails?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  supplierName?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  materialRequestId?: string;

  @ValidateNested({ each: true })
  @Field(() => [UpdatePurchaseOrderItemInput])
  items?: UpdatePurchaseOrderItemInput[];

  @IsOptional()
  @Field(() => Number, { nullable: true })
  subTotal?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  vat?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  grandTotal?: number;

  @IsOptional()
  @Field(() => String, { nullable: true })
  preparedById?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;

  @IsBoolean()
  @Field(() => Boolean, { nullable: true })
  approved?: boolean;
}
