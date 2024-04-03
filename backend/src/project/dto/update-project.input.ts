import { Field, InputType } from '@nestjs/graphql';
import { ValidateNested } from 'class-validator';
import { UpdateProjectUserInput } from './update-project-user.input';

@InputType()
export class UpdateProjectInput {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  startDate?: Date;

  @Field({ nullable: true })
  endDate?: Date;

  @Field(() => Number, { nullable: true })
  budget?: number;

  @Field({ nullable: true })
  clientId?: string;

  @Field({ nullable: true })
  projectManagerId?: string;

  @ValidateNested({ each: true })
  @Field(() => [UpdateProjectUserInput], { nullable: true })
  projectUsers?: UpdateProjectUserInput[];

  @Field({ nullable: true })
  status?: string;
}
