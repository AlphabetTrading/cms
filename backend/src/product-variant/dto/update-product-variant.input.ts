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

  @Field(() => String, { nullable: true })
  description?: string;
}
