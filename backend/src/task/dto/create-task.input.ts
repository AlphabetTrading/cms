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

  @Field()
  status: CompletionStatus;

  @Field()
  priority: Priority;

  @Field()
  assignedToId: string;

  @Field()
  milestoneId: string;
}