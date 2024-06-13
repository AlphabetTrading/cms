import { InputType, Field } from '@nestjs/graphql';
import { IsOptional, IsString, ValidateNested } from 'class-validator';
import { UpdateDailySiteDataTaskInput } from './update-daily-site-data-task.input';
import { ApprovalStatus } from '@prisma/client';

@InputType()
export class UpdateDailySiteDataInput {
  @IsString()
  @Field(() => String)
  id: string;

  @IsOptional()
  @Field(() => Date, { nullable: true })
  date?: Date;

  @IsOptional()
  @Field(() => String, { nullable: true })
  projectId?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  contractor?: string;

  @ValidateNested({ each: true })
  @Field(() => [UpdateDailySiteDataTaskInput], { nullable: true })
  tasks?: UpdateDailySiteDataTaskInput[];

  @IsOptional()
  @Field(() => String, { nullable: true })
  preparedById?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  checkedById?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => ApprovalStatus, { nullable: true })
  status?: ApprovalStatus;
}
