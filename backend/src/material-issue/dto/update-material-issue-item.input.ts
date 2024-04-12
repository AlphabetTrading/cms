import { Field, InputType, PartialType } from '@nestjs/graphql';
import { IsNotEmpty, IsString } from 'class-validator';
import { CreateMaterialIssueItemInput } from './create-material-issue-item.input';

@InputType()
export class UpdateMaterialIssueItemInput extends PartialType(
  CreateMaterialIssueItemInput,
) {
  @Field(() => String, { nullable: true })
  @IsString()
  productUseId?: string;

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
