import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, ValidateNested } from 'class-validator';
import { CreateMaterialRequestItemInput } from './create-material-request-item.input';
import { ApprovalStatus } from '@prisma/client';

@InputType()
export class CreateMaterialRequestInput {
  @IsNotEmpty()
  @Field(() => Date, {})
  date: Date;

  @IsNotEmpty()
  @Field(() => String)
  from: string;

  @IsNotEmpty()
  @Field(() => String)
  to: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateMaterialRequestItemInput])
  items: CreateMaterialRequestItemInput[];

  @IsNotEmpty()
  @Field(() => String)
  requestedById: string;

  @IsNotEmpty()
  @Field(() => String)
  approvedById: string;

  @Field(() => ApprovalStatus, { nullable: true })
  approved?: ApprovalStatus;
}
