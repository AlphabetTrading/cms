import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class ProductVariant extends BaseModel{
  @Field(() => String, { nullable: true })
  productId?: string;

  @Field(() => String, { nullable: true })
  variant?: string;

  @Field(() => String, { nullable: true })
  description?: string;
}