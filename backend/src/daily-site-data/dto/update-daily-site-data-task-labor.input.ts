import { InputType, Field, PartialType } from '@nestjs/graphql';
import { IsOptional, IsString } from 'class-validator';
import { CreateDailySiteDataTaskLaborInput } from './create-daily-site-data-task-labor.input';

@InputType()
export class UpdateDailySiteDataTaskLaborInput extends PartialType(
  CreateDailySiteDataTaskLaborInput,
) {
  @IsString()
  @Field(() => String)
  id: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  trade?: string;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  number?: number;


  @IsOptional()
  @Field(() => Number, { nullable: true })
  morning?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  afternoon?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  overtime?: number;
}
