import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsString, IsOptional } from 'class-validator';

@InputType()
export class CreateMaterialRequestItemInput {
  @Field(() => Number)
  @IsNotEmpty()
  listNo: number;

  @Field(() => String, { nullable: true })
  @IsOptional()
  @IsString()
  description?: string;

  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  unitOfMeasure: string;

  @Field(() => Number)
  @IsNotEmpty()
  quantity: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  inStockQuantity?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  toBePurchasedQuantity?: number;

  @IsOptional()
  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String)
  @IsNotEmpty()
  materialRequestVoucherId: string;
}
