import { Field, InputType, PartialType } from '@nestjs/graphql';
import { IsString } from 'class-validator';
import { CreateProjectUserInput } from './create-project-user.input';

@InputType()
export class UpdateProjectUserInput extends PartialType(
  CreateProjectUserInput,
) {
  @Field(() => String, { nullable: true })
  @IsString()
  projectId?: string;

  @Field(() => String, { nullable: true })
  @IsString()
  userId?: string;
}
