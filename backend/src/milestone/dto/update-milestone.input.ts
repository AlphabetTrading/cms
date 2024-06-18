import { UseType } from '@prisma/client';
import { CreateMilestoneInput } from './create-milestone.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateMilestoneInput extends PartialType(CreateMilestoneInput) {
  @Field(() => String)
  id: string;

  @Field(() => String, { nullable: true })
  name?: string;

  @Field(() => UseType, { nullable: true })
  stage?: UseType;

  @Field(() => String, { nullable: true })
  description?: string;

  @Field(() => Date, { nullable: true })
  dueDate?: Date;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => String, { nullable: true })
  createdById?: string;
}
