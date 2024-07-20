import { Field, InputType, PartialType } from '@nestjs/graphql';
import { IsOptional, ValidateNested } from 'class-validator';
import { CreateProformaItemInput } from './create-proforma-item.input';

@InputType()
export class UpdateProformaItemInput extends PartialType(
  CreateProformaItemInput,
) {
  @IsOptional()
  @Field(() => String, { nullable: true })
  id?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  vendor?: string;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  quantity?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  unitPrice?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  totalPrice?: number;

  @IsOptional()
  @Field(() => String, { nullable: true })
  remark?: string;

  @ValidateNested({ each: true })
  @Field(() => [String])
  photos?: string[];
}
