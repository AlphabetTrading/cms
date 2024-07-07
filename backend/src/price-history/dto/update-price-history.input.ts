import { CreatePriceHistoryInput } from './create-price-history.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdatePriceHistoryInput extends PartialType(
  CreatePriceHistoryInput,
) {
  @Field({ nullable: true })
  companyId?: string;

  @Field({ nullable: true })
  productVariantId?: string;

  @Field({ nullable: true })
  price?: number;
}
