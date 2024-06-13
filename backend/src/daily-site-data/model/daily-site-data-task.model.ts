import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { DailySiteData } from './daily-site-data.model';
import { DailySiteDataTaskLabor } from './daily-site-data-task-labor.model';
import { DailySiteDataTaskMaterial } from './daily-site-data-task-material.model';

@ObjectType()
export class DailySiteDataTask extends BaseModel {
  @Field(() => String, { nullable: true })
  description?: string;

  @Field(() => Number, { nullable: true })
  executedQuantity?: number;

  @Field(() => String, { nullable: true })
  unit?: string;

  @Field(() => [DailySiteDataTaskLabor], { nullable: true })
  laborDetails?: DailySiteDataTaskLabor[];

  @Field(() => [DailySiteDataTaskMaterial], { nullable: true })
  materialDetails?: DailySiteDataTaskMaterial[];

  @Field(() => String, { nullable: true })
  dailySiteDataId?: string;

  @Field(() => DailySiteData, { nullable: true })
  dailySiteData?: DailySiteData;
}
