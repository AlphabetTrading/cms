import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional, ValidateNested } from 'class-validator';
import { CreateMaterialIssueItemInput } from './create-material-issue-item.input';

@InputType()
export class CreateMaterialIssueInput {
  @IsNotEmpty()
  @Field(() => String)
  projectId: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  requisitionNumber?: string;

  @IsNotEmpty()
  @Field(() => String)
  warehouseStoreId: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateMaterialIssueItemInput])
  items: CreateMaterialIssueItemInput[];

  @IsNotEmpty()
  @Field(() => String)
  preparedById: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;
}
