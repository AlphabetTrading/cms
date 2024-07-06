import { InputType, Field } from '@nestjs/graphql';
import { Type } from 'class-transformer';
import { IsOptional, IsUUID, ValidateNested } from 'class-validator';
import { DateRange } from './filter-expense.input';

@InputType()
export class FilterStockInput {
  @Field(() => String)
  @IsUUID()
  projectId: string;

  //   @Field(() => ProductType, { nullable: true })
  //   @IsOptional()
  //   @IsEnum(ProductType)
  //   productType?: ProductType;

  //   @Field(() => String, { nullable: true })
  //   @IsOptional()
  //   @IsUUID()
  //   productId?: string;

  @Field(() => String, { nullable: true })
  @IsOptional()
  @IsUUID()
  productVariantId?: string;

  @Field({ nullable: true })
  @IsOptional()
  @ValidateNested()
  @Type(() => DateRange)
  dateRange?: DateRange;

  @Field(() => String, { nullable: true })
  @IsOptional()
  filterPeriod?: 'day' | 'week' | 'month' | 'year' | 'alltime';
}
