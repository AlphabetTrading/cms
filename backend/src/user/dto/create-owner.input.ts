import { Field, InputType } from '@nestjs/graphql';
import {
  IsEmail,
  IsNotEmpty,
  IsPhoneNumber,
  MaxLength,
} from 'class-validator';

@InputType()
export class CreateOwnerInput {
  @Field()
  @IsNotEmpty({ message: 'Full Name is required' })
  @MaxLength(50)
  fullName: string;

  @Field()
  @IsNotEmpty({ message: 'Email is required' })
  @IsEmail({}, { message: 'Email must be valid' })
  email: string;

  @Field()
  @IsNotEmpty({ message: 'Phone Number is required' })
  @IsPhoneNumber('ET', { message: 'Phone Number must be valid' })
  phoneNumber: string;
}
