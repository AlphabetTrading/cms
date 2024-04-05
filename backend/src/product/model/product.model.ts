import { Field, ObjectType } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class Product extends BaseModel {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  description?: string;
}
