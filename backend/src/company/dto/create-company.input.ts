import { InputType, Field } from '@nestjs/graphql';
import { IsNotEmpty } from 'class-validator';

@InputType()
export class CreateCompanyInput {
  @IsNotEmpty()
  @Field(() => String)
  name: string;

  @IsNotEmpty()
  @Field(() => String)
  address: string;

  @IsNotEmpty()
  @Field(() => String)
  contactInfo: string;

  @IsNotEmpty()
  @Field(() => String)
  ownerId: string;
}