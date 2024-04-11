import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsString, IsOptional } from 'class-validator';

@InputType()
export class CreateMaterialRequestItemInput {
  @Field(() => String)
  @IsNotEmpty()
  @IsString()
  productId: string;

  @Field(() => Number)
  @IsNotEmpty()
  quantity: number;

  @IsOptional()
  @Field(() => String, { nullable: true })
  remark?: string;
}
