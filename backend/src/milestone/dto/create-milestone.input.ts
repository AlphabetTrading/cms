import { InputType, Field } from "@nestjs/graphql";

@InputType()
export class CreateMilestoneInput {
  @Field()
  name: string;

  @Field({ nullable: true })
  description?: string;

  @Field()
  dueDate: Date;

  @Field()
  status: string;

  @Field()
  projectId: string;
}