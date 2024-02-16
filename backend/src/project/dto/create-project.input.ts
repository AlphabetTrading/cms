import { Field, InputType } from '@nestjs/graphql';

@InputType()
export class CreateProjectInput {
  @Field()
  name: string;

  @Field()
  startDate: Date;

  @Field({ nullable: true })
  endDate?: Date;

  @Field(() => Number)
  budget: number;

  @Field()
  clientId: string;

  @Field()
  projectManagerId: string;

  @Field()
  status: string;
}
