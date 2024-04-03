import { Field, InputType } from '@nestjs/graphql';
import { CreateProjectUserInput } from './create-project-user.input';
import { ValidateNested } from 'class-validator';

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

  @ValidateNested({ each: true })
  @Field(() => [CreateProjectUserInput])
  projectUsers: CreateProjectUserInput[];

  @Field()
  status: string;
}
