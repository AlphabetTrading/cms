import { Field, InputType, PartialType } from '@nestjs/graphql';
import { IsString } from 'class-validator';
import { CreateMaterialIssueItemInput } from './create-material-issue-item.input';
import { SubStructureUseDescription, SuperStructureUseDescription, UseType } from '@prisma/client';

@InputType()
export class UpdateMaterialIssueItemInput extends PartialType(
  CreateMaterialIssueItemInput,
) {
  @Field(() => String, { nullable: true })
  @IsString()
  productVariantId?: string;

  @Field(() => UseType, { nullable: true })
  useType?: UseType;

  @Field(() => SubStructureUseDescription, { nullable: true })
  subStructureDescription?: SubStructureUseDescription;

  @Field(() => SuperStructureUseDescription, { nullable: true })
  superStructureDescription?: SuperStructureUseDescription;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  unitCost?: number;

  @Field(() => Number, { nullable: true })
  totalCost?: number;

  @Field(() => String, { nullable: true })
  @IsString()
  remark?: string;
}
