import { InputType, Field } from '@nestjs/graphql';
import { IsNotEmpty, IsString, IsOptional } from 'class-validator';

@InputType()
export class CreateMaterialTransferItemInput {
  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  productVariantId: string;

  @Field(() => Number, { nullable: true })
  @IsOptional()
  quantityRequested?: number;

  @Field(() => Number)
  @IsNotEmpty()
  quantityTransferred: number;

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
