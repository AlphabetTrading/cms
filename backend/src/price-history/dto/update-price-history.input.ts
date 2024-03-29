import { CreatePriceHistoryInput } from './create-price-history.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdatePriceHistoryInput extends PartialType(
  CreatePriceHistoryInput,
) {
  @Field({ nullable: true })
  productId?: string;

  @Field({ nullable: true })
  price?: number;
}
