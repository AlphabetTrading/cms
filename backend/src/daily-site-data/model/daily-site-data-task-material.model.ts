import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { DailySiteDataTask } from './daily-site-data-task.model';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';

@ObjectType()
export class DailySiteDataTaskMaterial extends BaseModel {
  @Field(() => String, { nullable: true })
  productVariantId?: string;

  @Field(() => ProductVariant, { nullable: true })
  productVariant?: ProductVariant;

  @Field(() => Number, { nullable: true })
  quantityUsed?: number;

  @Field(() => Number, { nullable: true })
  quantityWasted?: number;

  @Field(() => String, { nullable: true })
  dailySiteDataTaskId?: string;

  @Field(() => DailySiteDataTask, { nullable: true })
  dailySiteDataTask?: DailySiteDataTask;
}
