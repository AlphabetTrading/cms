import { Field, InputType } from '@nestjs/graphql';
import { IsOptional, IsString } from 'class-validator';

@InputType()
export class UpdateMaterialReceiveItemInput {
  @Field(() => String, { nullable: true })
  @IsOptional()
  @IsString()
  purchaseOrderItemId?: string;

  @Field(() => Number, { nullable: true })
  @IsOptional()
  receivedQuantity?: number;

  @Field(() => Number, { nullable: true })
  @IsOptional()
  loadingCost?: number;

  @Field(() => Number, { nullable: true })
  @IsOptional()
  unloadingCost?: number;

  @Field(() => Number, { nullable: true })
  @IsOptional()
  transportationCost?: number;

  @Field(() => String, { nullable: true })
  @IsOptional()
  @IsString()
  remark?: string;
}
