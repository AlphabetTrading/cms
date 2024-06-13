import { InputType, Field } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional, ValidateNested } from 'class-validator';
import { CreateDailySiteDataTaskLaborInput } from './create-daily-site-data-task-labor.input';
import { CreateDailySiteDataTaskMaterialInput } from './create-daily-site-data-task-material.input';

@InputType()
export class CreateDailySiteDataTaskInput {
  @IsNotEmpty()
  @Field(() => String)
  description: string;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  executedQuantity?: number;

  @IsOptional()
  @Field(() => String, { nullable: true })
  unit?: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateDailySiteDataTaskLaborInput])
  laborDetails: CreateDailySiteDataTaskLaborInput[];

  @ValidateNested({ each: true })
  @Field(() => [CreateDailySiteDataTaskMaterialInput])
  materialDetails: CreateDailySiteDataTaskMaterialInput[];
}
