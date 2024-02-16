import { Field, InputType, PartialType } from '@nestjs/graphql';
import { CreateProjectInput } from './create-project.input';

@InputType()
export class UpdateProjectInput extends PartialType(CreateProjectInput) {
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

  @Field({ nullable: true })
  status?: string;
}
