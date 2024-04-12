import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsString } from 'class-validator';

@InputType()
export class CreateMaterialReceiveItemInput {
  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  productVariantId: string;

  @Field(() => Number)
  @IsNotEmpty()
  quantity: number;

  @Field(() => Number)
  @IsNotEmpty()
  unitCost: number;

  @Field(() => Number)
  @IsNotEmpty()
  totalCost: number;
}
