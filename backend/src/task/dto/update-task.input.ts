import { CompletionStatus, Priority } from '@prisma/client';
import { CreateTaskInput } from './create-task.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateTaskInput extends PartialType(CreateTaskInput) {
  @Field()
  id: string;

  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  description?: string;

  @Field({ nullable: true })
  startDate?: Date;

  @Field({ nullable: true })
  dueDate?: Date;

  @Field(() => CompletionStatus, { nullable: true })
  status?: CompletionStatus;

  @Field(() => Priority, { nullable: true })
  priority?: Priority;

  @Field({ nullable: true })
  assignedToId?: string;

  @Field({ nullable: true })
  milestoneId?: string;
}
