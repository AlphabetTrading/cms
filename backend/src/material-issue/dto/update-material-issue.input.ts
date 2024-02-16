import { Field, InputType } from '@nestjs/graphql';
import { IsString, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { UpdateMaterialIssueItemInput } from './update-material-issue-item.input';

@InputType()
export class UpdateMaterialIssueInput {
  @Type(() => Date)
  @Field(() => Date, { nullable: true })
  date?: Date;

  @IsString()
  @Field(() => String, { nullable: true })
  projectDetails?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  issuedToId?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  requisitionNumber?: string;

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

  @IsString()
  @Field(() => String, { nullable: true })
  receivedById?: string;
}
