import { UnitOfMeasure } from '@prisma/client';
import { CreateProductVariantInput } from './create-product-variant.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateProductVariantInput extends PartialType(
  CreateProductVariantInput,
) {
  @Field(() => String, { nullable: true })
  productId?: string;

  @Field(() => String, { nullable: true })
  variant?: string;

  @Field(() => UnitOfMeasure, { nullable: true })
  unitOfMeasure?: UnitOfMeasure;

  @Field(() => String, { nullable: true })
  description?: string;
}
