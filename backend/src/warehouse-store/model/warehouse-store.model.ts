import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class WarehouseStore extends BaseModel {
  @Field()
  name?: string;

  @Field()
  location?: string;
}
