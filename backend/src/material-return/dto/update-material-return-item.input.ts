import { Field, InputType, PartialType } from '@nestjs/graphql';
import { IsString } from 'class-validator';
import { CreateMaterialReturnItemInput } from './create-material-return-item.input';

@InputType()
export class UpdateMaterialReturnItemInput extends PartialType(
  CreateMaterialReturnItemInput,
) {
  @Field(() => String, { nullable: true })
  @IsString()
  productId?: string;

  @Field(() => String, { nullable: true })
  @IsString()
  issueVoucherId?: string;

  @Field(() => String, { nullable: true })
  @IsString()
  unitOfMeasure?: string;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  unitCost?: number;

  @Field(() => Number, { nullable: true })
  totalCost?: number;

  @Field(() => String, { nullable: true })
  remark?: string;
}
