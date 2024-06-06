import { InputType, Int, Field } from '@nestjs/graphql';

@InputType()
export class CreateDailySiteDatumInput {
  @Field(() => Int, { description: 'Example field (placeholder)' })
  exampleField: number;
}
