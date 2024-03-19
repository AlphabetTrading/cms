import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsPhoneNumber } from 'class-validator';

@InputType()
export class LoginInput {
  @Field()
  @IsNotEmpty({ message: 'Phone Number is required' })
  @IsPhoneNumber('ET', { message: 'Phone Number is not valid' })
  phone_number: string;

  @Field()
  @IsNotEmpty({ message: 'Password is required' })
  password: string;
}
