import { Field, InputType } from '@nestjs/graphql';
import { IsBoolean, IsString, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { UpdateMaterialReceiveItemInput } from './update-material-receive-item.input';

@InputType()
export class UpdateMaterialReceiveInput {
  @Type(() => Date)
  @Field(() => Date, { nullable: true })
  date: Date;

  @IsString()
  @Field(() => String, { nullable: true })
  projectDetails?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  supplierName: string;

  @IsString()
  @Field(() => String, { nullable: true })
  invoiceId: string;

  @IsString()
  @Field(() => String, { nullable: true })
  materialRequestId?: string;

  @ValidateNested({ each: true })
  @Type(() => UpdateMaterialReceiveItemInput)
  @Field(() => [UpdateMaterialReceiveItemInput], { nullable: true })
  items?: UpdateMaterialReceiveItemInput[];

  @IsString()
  @Field(() => String, { nullable: true })
  purchaseOrderId: string;

  @IsString()
  @Field(() => String, { nullable: true })
  purchasedById: string;

  @IsString()
  @Field(() => String, { nullable: true })
  receivedById?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  approvedById: string;

  @IsBoolean()
  @Field(() => Boolean, { nullable: true })
  approved?: boolean;
}