import { ObjectType, Field } from '@nestjs/graphql';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';
import { Project } from 'src/project/model/project.model';

@ObjectType()
export class DailyStockBalanceItem {
  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  project?: Project;

  @Field(() => String, { nullable: true })
  productVariantId?: string;

  @Field(() => ProductVariant, { nullable: true })
  productVariant?: ProductVariant;

  @Field(() => Number, { nullable: true })
  previousQuantity?: number;

  @Field(() => Number, { nullable: true })
  quantityIssuedToday?: number;

  @Field(() => Number, { nullable: true })
  currentQuantity?: number;
}