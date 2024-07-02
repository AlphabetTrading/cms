import { Field, InputType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { IsOptional, IsString } from 'class-validator';

@InputType()
export class UpdateProformaInput {
  @IsString()
  @Field(() => String)
  id: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  projectId?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  materialRequestItemId?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  vendor?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  remark?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  photo?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  preparedById?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => ApprovalStatus, { nullable: true })
  status?: ApprovalStatus;
}
