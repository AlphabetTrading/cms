import { Field, InputType } from '@nestjs/graphql';
import { IsOptional, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { UpdateMaterialReceiveItemInput } from './update-material-receive-item.input';
import { ApprovalStatus } from '@prisma/client';

@InputType()
export class UpdateMaterialReceiveInput {
  @IsOptional()
  @Field(() => String)
  id: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  projectId?: string;

  @ValidateNested({ each: true })
  @Type(() => UpdateMaterialReceiveItemInput)
  @Field(() => [UpdateMaterialReceiveItemInput], { nullable: true })
  items?: UpdateMaterialReceiveItemInput[];

  @IsOptional()
  @Field(() => String, { nullable: true })
  preparedById?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  warehouseStoreId?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => ApprovalStatus, { nullable: true })
  status?: ApprovalStatus;
}
