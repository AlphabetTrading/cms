import { CreateDailySiteDatumInput } from './create-daily-site-datum.input';
import { InputType, Field, Int, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateDailySiteDatumInput extends PartialType(CreateDailySiteDatumInput) {
  @Field(() => Int)
  id: number;
}
