import { ProductType } from '@prisma/client';
import { CreateProductInput } from './create-product.input';
import { InputType, Field, PartialType, registerEnumType } from '@nestjs/graphql';

registerEnumType(ProductType, {
  name: 'ProductType',
});

@InputType()
export class UpdateProductInput extends PartialType(CreateProductInput) {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  productType?: ProductType;

}
