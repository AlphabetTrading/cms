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
  @Field(() => Number, { nullable: true })
  quantity?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  unitPrice?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  totalPrice?: number;

  @IsOptional()
  @Field(() => String, { nullable: true })
  remark?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  preparedById?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => ApprovalStatus, { nullable: true })
  status?: ApprovalStatus;
}
