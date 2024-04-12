import { ObjectType, Field } from '@nestjs/graphql';
import { UnitOfMeasure } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { Product } from 'src/product/model/product.model';

@ObjectType()
export class ProductVariant extends BaseModel {
  @Field(() => String, { nullable: true })
  productId?: string;

  @Field(() => Product, { nullable: true })
  product?: Product;

  @Field(() => String, { nullable: true })
  variant?: string;

  @Field(() => UnitOfMeasure, { nullable: true })
  unitOfMeasure?: UnitOfMeasure;

  @Field(() => String, { nullable: true })
  description?: string;
}
