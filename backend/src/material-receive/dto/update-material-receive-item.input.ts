import { Field, InputType, PartialType } from '@nestjs/graphql';
import { IsString } from 'class-validator';
import { CreateMaterialReceiveItemInput } from './create-material-receive-item.input';

@InputType()
export class UpdateMaterialReceiveItemInput extends PartialType(
  CreateMaterialReceiveItemInput,
) {
  @Field(() => String, { nullable: true })
  @IsString()
  productVariantId?: string;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  unitCost?: number;

  @Field(() => Number, { nullable: true })
  totalCost?: number;

  @Field(() => Number, { nullable: true })
  unloadingCost?: number;

  @Field(() => Number, { nullable: true })
  loadingCost?: number;

  @Field(() => Number, { nullable: true })
  transportationCost?: number;
}
