import { InputType, Field } from '@nestjs/graphql';
import { IsOptional, IsString, ValidateNested } from 'class-validator';
import { UpdateDailySiteDataTaskLaborInput } from './update-daily-site-data-task-labor.input';
import { UpdateDailySiteDataTaskMaterialInput } from './update-daily-site-data-task-material.input';

@InputType()
export class UpdateDailySiteDataTaskInput {
  @IsString()
  @Field(() => String)
  id: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  description?: string;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  executedQuantity?: number;

  @IsOptional()
  @Field(() => String, { nullable: true })
  unit?: string;

  @ValidateNested({ each: true })
  @Field(() => [UpdateDailySiteDataTaskLaborInput], { nullable: true })
  laborDetails?: UpdateDailySiteDataTaskLaborInput[];

  @ValidateNested({ each: true })
  @Field(() => [UpdateDailySiteDataTaskMaterialInput], { nullable: true })
  materialDetails?: UpdateDailySiteDataTaskMaterialInput[];
}
