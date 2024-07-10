import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional } from 'class-validator';

@InputType()
export class CreateProformaItemInput {
  @IsNotEmpty()
  @Field(() => String)
  vendor: string;

  @IsNotEmpty()
  @Field(() => Number)
  quantity: number;

  @IsNotEmpty()
  @Field(() => Number)
  unitPrice: number;

  @IsNotEmpty()
  @Field(() => Number)
  totalPrice: number;

  @IsOptional()
  @Field(() => String, { nullable: true })
  remark?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  photo?: string;
}
