import { Field, InputType } from '@nestjs/graphql';

@InputType()
export class NumberFilter {
  @Field(() => Number, { nullable: true })
  equals?: number;

  @Field(() => Number, { nullable: true })
  lt?: number;

  @Field(() => Number, { nullable: true })
  lte?: number;

  @Field(() => Number, { nullable: true })
  gt?: number;

  @Field(() => Number, { nullable: true })
  gte?: number;
}
