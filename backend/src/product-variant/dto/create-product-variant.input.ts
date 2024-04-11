import { InputType, Field, registerEnumType } from '@nestjs/graphql';
import { UnitOfMeasure } from '@prisma/client';

registerEnumType(UnitOfMeasure, {
  name: "UnitOfMeasure",
  description: "Possible variations of unit of measure"
})
@InputType()
export class CreateProductVariantInput {
  @Field(() => String)
  productId: string;

  @Field(() => String)
  variant: string;

  @Field(() => UnitOfMeasure)
  unitOfMeasure: UnitOfMeasure;

  @Field(() => String, { nullable: true })
  description?: string;
}
