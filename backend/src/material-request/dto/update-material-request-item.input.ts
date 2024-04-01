import { Field, InputType, PartialType } from '@nestjs/graphql';
import { IsNotEmpty, IsString } from 'class-validator';
import { CreateMaterialRequestItemInput } from './create-material-request-item.input';

@InputType()
export class UpdateMaterialRequestItemInput extends PartialType(
  CreateMaterialRequestItemInput,
) {
  @Field(() => String, { nullable: true })
  @IsString()
  description?: string;

  @Field(() => String, { nullable: true })
  @IsString()
  unitOfMeasure?: string;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  inStockQuantity?: number;

  @Field(() => Number, { nullable: true })
  toBePurchasedQuantity?: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String, { nullable: true })
  @IsNotEmpty()
  materialRequestVoucherId?: string;
}
