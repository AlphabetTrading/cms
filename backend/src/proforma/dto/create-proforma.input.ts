import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional } from 'class-validator';

@InputType()
export class CreateProformaInput {
  @IsNotEmpty()
  @Field(() => String)
  projectId: string;

  @IsNotEmpty()
  @Field(() => String)
  materialRequestItemId: string;

  @IsNotEmpty()
  @Field(() => String)
  vendor: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  remark?: string;

  @IsNotEmpty()
  @Field(() => String)
  photo: string;

  @IsNotEmpty()
  @Field(() => String)
  preparedById: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;

}
