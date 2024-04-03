import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsString } from 'class-validator';

@InputType()
export class CreateProjectUserInput {
  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  projectId: string;

  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  userId: string;

}
