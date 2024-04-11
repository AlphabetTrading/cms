import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsString, IsOptional } from 'class-validator';

@InputType()
export class CreateMaterialReturnItemInput {
  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  productId: string;

  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  issueVoucherId: string;

  @Field(() => Number)
  @IsNotEmpty()
  quantity: number;

  @Field(() => Number)
  @IsNotEmpty()
  unitCost: number;

  @Field(() => Number)
  @IsNotEmpty()
  totalCost: number;

  @Field(() => String, { nullable: true })
  @IsOptional()
  remark?: string;
}
