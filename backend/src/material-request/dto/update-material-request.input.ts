import { Field, InputType } from '@nestjs/graphql';
import { IsString, ValidateNested } from 'class-validator';
import { UpdateMaterialRequestItemInput } from './update-material-request-item.input';
import { ApprovalStatus } from '@prisma/client';

@InputType()
export class UpdateMaterialRequestInput {
  @IsString()
  @Field(() => String)
  id: string;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @ValidateNested({ each: true })
  @Field(() => [UpdateMaterialRequestItemInput], { nullable: true })
  items?: UpdateMaterialRequestItemInput[];

  @Field(() => String, { nullable: true })
  requestedById?: string;

  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => ApprovalStatus, { nullable: true })
  status?: ApprovalStatus;
}
