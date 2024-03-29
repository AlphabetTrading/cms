import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class CreatePriceHistoryInput {
  @Field()
  productId: string;

  @Field()
  price: number;
}
