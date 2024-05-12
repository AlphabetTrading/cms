import { IsString } from 'class-validator';
import { CreateMaterialTransferItemInput } from './create-material-transfer-item.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateMaterialTransferItemInput extends PartialType(
  CreateMaterialTransferItemInput,
) {
  @Field(() => String, { nullable: true })
  @IsString()
  productVariantId: string;

  @Field(() => Number, { nullable: true })
  quantityRequested?: number;

  @Field(() => Number, { nullable: true })
  quantityTransferred?: number;

  @Field(() => Number, { nullable: true })
  unitCost: number;

  @Field(() => Number, { nullable: true })
  totalCost: number;

  @Field(() => String, { nullable: true })
  @IsString()
  remark?: string;
}
