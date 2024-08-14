import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsString } from 'class-validator';

@InputType()
export class CreateMaterialReceiveItemInput {
  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  purchaseOrderItemId: string;

  @Field(() => Number)
  @IsNotEmpty()
  receivedQuantity: number;

  @Field(() => Number)
  @IsNotEmpty()
  unloadingCost: number;

  @Field(() => Number)
  @IsNotEmpty()
  loadingCost: number;

  @Field(() => Number)
  @IsNotEmpty()
  transportationCost: number;
}
