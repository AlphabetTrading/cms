import { Field, InputType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { IsOptional, IsString, ValidateNested } from 'class-validator';
import { UpdateProformaItemInput } from './update-proforma-item.input';

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

  @ValidateNested({ each: true })
  @Field(() => [UpdateProformaItemInput])
  items: UpdateProformaItemInput[];

  @IsOptional()
  @Field(() => String, { nullable: true })
  preparedById?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => ApprovalStatus, { nullable: true })
  status?: ApprovalStatus;
}
