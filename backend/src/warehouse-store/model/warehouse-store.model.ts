import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class WarehouseStore extends BaseModel {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  location?: string;
}
