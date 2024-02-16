import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class CreateTaskInput {
  @Field()
  name: string;

  @Field({ nullable: true })
  description?: string;

  @Field()
  startDate: Date;

  @Field()
  dueDate: Date;

  @Field()
  status: string;

  @Field()
  priority: string;

  @Field()
  assignedToId: string;

  @Field()
  milestoneId: string;
}