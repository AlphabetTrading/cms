import { Field, InputType } from '@nestjs/graphql';
import { IsString, ValidateNested } from 'class-validator';
import { UpdateMaterialReturnItemInput } from './update-material-return-item.input';
import { ApprovalStatus } from '@prisma/client';

@InputType()
export class UpdateMaterialReturnInput {
  @IsString()
  @Field(() => String)
  id: string;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => String, { nullable: true })
  receivingWarehouseStoreId?: string;

  @ValidateNested({ each: true })
  @Field(() => [UpdateMaterialReturnItemInput], { nullable: true })
  items?: UpdateMaterialReturnItemInput[];

  @Field(() => String, { nullable: true })
  returnedById?: string;

  @Field(() => String, { nullable: true })
  receivedById?: string;

  @Field({ nullable: true })
  status?: ApprovalStatus;
}
