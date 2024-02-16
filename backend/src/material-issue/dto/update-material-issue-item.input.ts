import { Field, InputType, PartialType } from '@nestjs/graphql';
import { IsNotEmpty, IsString } from 'class-validator';
import { CreateMaterialIssueItemInput } from './create-material-issue-item.input';

@InputType()
export class UpdateMaterialIssueItemInput extends PartialType(
  CreateMaterialIssueItemInput,
) {
  @Field(() => Number, { nullable: true })
  listNo?: number;

  @Field(() => String, { nullable: true })
  @IsString()
  description?: string;

  @Field(() => String, { nullable: true })
  @IsString()
  unitOfMeasure?: string;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  unitCost?: number;

  @Field(() => Number, { nullable: true })
  @IsNotEmpty()
  totalCost?: number;

  @Field(() => String, { nullable: true })
  @IsString()
  remark?: string;
}
