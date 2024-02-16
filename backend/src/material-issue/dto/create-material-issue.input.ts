import { Field, InputType } from '@nestjs/graphql';
import {
  IsBoolean,
  IsNotEmpty,
  IsOptional,
  ValidateNested,
} from 'class-validator';
import { CreateMaterialIssueItemInput } from './create-material-issue-item.input';

@InputType()
export class CreateMaterialIssueInput {
  @IsNotEmpty()
  @Field(() => Date, {})
  date: Date;

  @IsOptional()
  @Field(() => String, { nullable: true })
  projectDetails?: string;

  @IsNotEmpty()
  @Field(() => String)
  issuedToId: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  requisitionNumber?: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateMaterialIssueItemInput])
  items: CreateMaterialIssueItemInput[];

  @IsNotEmpty()
  @Field(() => String)
  preparedById: string;

  @IsNotEmpty()
  @Field(() => String)
  approvedById: string;

  @IsBoolean()
  @Field(() => Boolean, { nullable: true })
  approved?: boolean;

  @IsOptional()
  @Field(() => String, { nullable: true })
  receivedById?: string;
}
