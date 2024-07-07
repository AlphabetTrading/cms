import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class CreatePriceHistoryInput {
  @Field()
  productVariantId: string;

  @Field()
  companyId: string;

  @Field()
  price: number;
}
