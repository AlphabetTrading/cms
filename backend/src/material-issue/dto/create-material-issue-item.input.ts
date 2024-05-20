import { Field, InputType } from '@nestjs/graphql';
import {
  SubStructureUseDescription,
  SuperStructureUseDescription,
  UseType,
} from '@prisma/client';
import { IsNotEmpty, IsString, IsOptional } from 'class-validator';

@InputType()
export class CreateMaterialIssueItemInput {
  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  productVariantId: string;

  @Field(() => UseType)
  useType: UseType;

  @Field(() => SubStructureUseDescription, { nullable: true })
  subStructureDescription?: SubStructureUseDescription;

  @Field(() => SuperStructureUseDescription, { nullable: true })
  superStructureDescription?: SuperStructureUseDescription;

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
