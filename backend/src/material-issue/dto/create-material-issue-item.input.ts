import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsString, IsOptional } from 'class-validator';

@InputType()
export class CreateMaterialIssueItemInput {
  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  description: string;

  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  unitOfMeasure: string;

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
  @IsString()
  remark?: string;
}
