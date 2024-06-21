import { InputType, Field } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional } from 'class-validator';

@InputType()
export class CreateDailySiteDataTaskLaborInput {
  @IsNotEmpty()
  @Field(() => String)
  trade: string;

  @IsNotEmpty()
  @Field(() => Number)
  number: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  morning?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  afternoon?: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  overtime?: number;
}
