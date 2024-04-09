import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class CreateProductVariantInput {
  @Field(() => String)
  productId: string;

  @Field(() => String)
  variant: string;

  @Field(() => String, { nullable: true })
  description?: string;
}
