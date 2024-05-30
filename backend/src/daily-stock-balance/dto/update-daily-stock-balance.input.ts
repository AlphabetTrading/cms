import { CreateDailyStockBalanceInput } from './create-daily-stock-balance.input';
import { InputType, Field, Int, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateDailyStockBalanceInput extends PartialType(CreateDailyStockBalanceInput) {
  @Field(() => Int)
  id: number;
}
