import { CreateMilestoneInput } from './create-milestone.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateMilestoneInput extends PartialType(CreateMilestoneInput) {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  description?: string;

  @Field({ nullable: true })
  dueDate?: Date;

  @Field({ nullable: true })
  status?: string;

  @Field({ nullable: true })
  projectId?: string;
}
