import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, ValidateNested } from 'class-validator';
import { CreateMaterialReturnItemInput } from './create-material-return-item.input';
import { ApprovalStatus } from '@prisma/client';

@InputType()
export class CreateMaterialReturnInput {
  @IsNotEmpty()
  @Field(() => Date)
  date: Date;

  @IsNotEmpty()
  @Field(() => String)
  from: string;

  @IsNotEmpty()
  @Field(() => String)
  receivingStore: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateMaterialReturnItemInput])
  items: CreateMaterialReturnItemInput[];

  @IsNotEmpty()
  @Field(() => String)
  returnedById: string;

  @IsNotEmpty()
  @Field(() => String)
  receivedById: string;

  @Field(() => ApprovalStatus, { nullable: true })
  approved?: ApprovalStatus;
}
