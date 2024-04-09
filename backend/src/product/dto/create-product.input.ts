import { InputType, Field, registerEnumType } from '@nestjs/graphql';
import { ProductType } from '@prisma/client';

registerEnumType(ProductType, {
  name: 'ProductType',
});
@InputType()
export class CreateProductInput {
  @Field()
  name: string;

  @Field()
  productType: ProductType;
}
