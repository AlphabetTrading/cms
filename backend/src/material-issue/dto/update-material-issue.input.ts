import { Field, InputType } from '@nestjs/graphql';
import { IsString, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { UpdateMaterialIssueItemInput } from './update-material-issue-item.input';
import { ApprovalStatus } from '@prisma/client';

@InputType()
export class UpdateMaterialIssueInput {
  @IsString()
  @Field(() => String)
  id: string;

  @IsString()
  @Field(() => String, { nullable: true })
  projectId?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  requisitionNumber?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  warehouseStoreId?: string;

  @ValidateNested({ each: true })
  @Type(() => UpdateMaterialIssueItemInput)
  @Field(() => [UpdateMaterialIssueItemInput], { nullable: true })
  items?: UpdateMaterialIssueItemInput[];

  @IsString()
  @Field(() => String, { nullable: true })
  preparedById?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => ApprovalStatus, { nullable: true })
  approved?: ApprovalStatus;
}
