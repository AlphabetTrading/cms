import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsStrongPassword } from 'class-validator';

@InputType()
export class RegistrationInput {
  @Field()
  @IsNotEmpty({ message: 'Token is required' })
  token: string;

  @Field()
  @IsNotEmpty({ message: 'Password is required' })
  @IsStrongPassword({
    minLength: 8,
    minLowercase: 1,
    minNumbers: 1,
    minSymbols: 1,
    minUppercase: 1,
  })
  password: string;

  @Field()
  @IsNotEmpty({ message: 'Confirm Password can not be empty' })
  confirmPassword: string;
}
