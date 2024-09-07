import { Field, ObjectType } from '@nestjs/graphql';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';

@ObjectType()
export class SpendingHistory {
  @Field(() => String, { nullable: true })
  productVariantId?: string;

  @Field(() => ProductVariant, { nullable: true })
  productVariant?: ProductVariant;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  itemCost?: number;

  @Field(() => Date, { nullable: true })
  date?: Date;
}

@ObjectType()
export class Expenditure {
  @Field(() => Number, { nullable: true })
  totalItemCost?: number;

  @Field(() => Number, { nullable: true })
  totalLaborCost?: number;

  @Field(() => Number, { nullable: true })
  totalTransportationCost?: number;

  @Field(() => Number, { nullable: true })
  totalExpenditure?: number;
}

@ObjectType()
export class Duration {
  @Field(() => Number, { nullable: true })
  days?: number;

  @Field(() => Number, { nullable: true })
  hours?: number;

  @Field(() => Number, { nullable: true })
  minutes?: number;

  @Field(() => Number, { nullable: true })
  seconds?: number;
}

@ObjectType()
export class DashboardStat {
  @Field(() => Number, { nullable: true })
  progress?: number;

  @Field(() => Duration, { nullable: true })
  duration?: Duration;

  @Field(() => Expenditure, { nullable: true })
  expenditure?: Expenditure;
}

@ObjectType()
export class DetailedExpenseStat {
  @Field(() => Number, { nullable: true })
  totalItemCost?: number;

  @Field(() => Number, { nullable: true })
  totalItemCount?: number;

  @Field(() => [SpendingHistory], { nullable: true })
  spendingHistory?: SpendingHistory[];
}

@ObjectType()
export class DetailedStockStat {
  @Field(() => Number, { nullable: true })
  totalItemUsed?: number;

  @Field(() => Number, { nullable: true })
  totalItemWasted?: number;

  @Field(() => Number, { nullable: true })
  totalItemBought?: number;

  @Field(() => Number, { nullable: true })
  totalItemLost?: number;
}
