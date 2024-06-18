import { InputType, Field } from '@nestjs/graphql';
import { UseType } from '@prisma/client';

@InputType()
export class CreateMilestoneInput {
  @Field(() => String)
  name: string;

  @Field(() => UseType)
  stage: UseType;

  @Field(() => String, { nullable: true })
  description?: string;

  @Field(() => Date)
  dueDate: Date;

  @Field(() => String)
  projectId: string;

  @Field(() => String)
  createdById: string;
}
