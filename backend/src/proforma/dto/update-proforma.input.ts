import { Field, InputType } from '@nestjs/graphql';
import { IsArray, IsString } from 'class-validator';

@InputType()
export class UpdateProformaInput {
  @IsString()
  @Field(() => String, { nullable: true })
  materialRequestId?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  vendor?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  description?: string;

  @IsArray()
  @Field(() => [String])
  photos?: string[];
}
