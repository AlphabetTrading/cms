import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional } from 'class-validator';

@InputType()
export class CreateProformaInput {
  @IsNotEmpty()
  @Field(() => String)
  projectId: string;

  @IsNotEmpty()
  @Field(() => String)
  materialRequestId: string;

  @IsNotEmpty()
  @Field(() => String)
  vendor: string;

  @IsOptional()
  @Field(() => String)
  description?: string;

  @IsOptional()
  @Field(() => [String])
  photos?: string[];
}
