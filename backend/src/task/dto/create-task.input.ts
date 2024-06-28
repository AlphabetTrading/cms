import { InputType, Field } from '@nestjs/graphql';
import { CompletionStatus, Priority } from '@prisma/client';

@InputType()
export class CreateTaskInput {
  @Field()
  name: string;

  @Field({ nullable: true })
  description?: string;

  @Field()
  dueDate: Date;

  @Field(() => CompletionStatus)
  status: CompletionStatus;

  @Field(() => Priority)
  priority: Priority;

  @Field()
  assignedToId: string;

  @Field()
  milestoneId: string;
}
