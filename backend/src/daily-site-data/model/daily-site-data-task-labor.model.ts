import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { DailySiteDataTask } from './daily-site-data-task.model';

@ObjectType()
export class DailySiteDataTaskLabor extends BaseModel {
  @Field(() => String, { nullable: true })
  trade?: string;

  @Field(() => Number, { nullable: true })
  morning?: number;

  @Field(() => Number, { nullable: true })
  afternoon?: number;

  @Field(() => Number, { nullable: true })
  overtime?: number;

  @Field(() => String, { nullable: true })
  dailySiteDataTaskId?: string;

  @Field(() => DailySiteDataTask, { nullable: true })
  dailySiteDataTask?: DailySiteDataTask;
}
