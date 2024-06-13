import { InputType, Field } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional } from 'class-validator';

@InputType()
export class CreateDailySiteDataTaskMaterialInput {
  @IsNotEmpty()
  @Field(() => String)
  productVariantId: string;

  @IsNotEmpty()
  @Field(() => Number)
  quantityUsed: number;

  @IsOptional()
  @Field(() => Number, { nullable: true })
  quantityWasted: number;
}
