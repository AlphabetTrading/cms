import { InputType, Field } from '@nestjs/graphql';
import { ProductType } from '@prisma/client';
import { Type } from 'class-transformer';
import { IsOptional, IsUUID, IsEnum, IsDate, ValidateNested } from 'class-validator';

@InputType()
export class DateRange {
  @Field()
  @IsDate()
  start: Date;

  @Field()
  @IsDate()
  end: Date;
}


@InputType()
export class FilterExpenseInput {
  @Field(() => String)
  @IsUUID()
  projectId: string;

  @Field(() => ProductType, { nullable: true })
  @IsOptional()
  @IsEnum(ProductType)
  productType?: ProductType;

  @Field(() => String, { nullable: true })
  @IsOptional()
  @IsUUID()
  productId?: string;

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
