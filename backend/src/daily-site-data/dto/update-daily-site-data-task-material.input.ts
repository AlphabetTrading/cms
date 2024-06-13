import { InputType, Field, PartialType } from '@nestjs/graphql';
import { IsOptional, IsString } from 'class-validator';
import { CreateDailySiteDataTaskMaterialInput } from './create-daily-site-data-task-material.input';

@InputType()
export class UpdateDailySiteDataTaskMaterialInput extends PartialType(
  CreateDailySiteDataTaskMaterialInput,
) {
  @IsString()
  @Field(() => String)
  id: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  productVariantId?: string;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  quantityUsed?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  quantityWasted?: number;
}
