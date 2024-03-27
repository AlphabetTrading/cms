import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional, ValidateNested } from 'class-validator';
import { CreateMaterialReceiveItemInput } from './create-material-receive-item.input';

@InputType()
export class CreateMaterialReceiveInput {
  @IsOptional()
  @Field(() => String, { nullable: true })
  projectDetails?: string;

  @IsNotEmpty()
  @Field(() => String)
  supplierName: string;

  @IsNotEmpty()
  @Field(() => String)
  invoiceId: string;

  @IsNotEmpty()
  @Field(() => String)
  materialRequestId: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateMaterialReceiveItemInput])
  items: CreateMaterialReceiveItemInput[];

  @IsNotEmpty()
  @Field(() => String)
  purchaseOrderId: string;

  @IsNotEmpty()
  @Field(() => String)
  purchasedById: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  receivedById?: string;

  @IsNotEmpty()
  @Field(() => String)
  approvedById: string;
}
