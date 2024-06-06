import { InputType, Int, Field } from '@nestjs/graphql';

@InputType()
export class CreateDailyStockBalanceInput {
  @Field(() => Int, { description: 'Example field (placeholder)' })
  exampleField: number;
}
