import { ObjectType, Field } from '@nestjs/graphql';
import { GraphQLJSONObject } from 'graphql-scalars';
import { BaseModel } from 'src/common/models/base.model';
import { Project } from 'src/project/model/project.model';

@ObjectType()
export class DailyStockBalance extends BaseModel {
  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  project?: Project;

  @Field(() => GraphQLJSONObject)
  changes?: Record<string, any>;
}
