import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class CreatePriceHistoryInput {
  @Field()
  productVariantId: string;

  @Field()
  projectId: string;

  @Field()
  price: number;
}
