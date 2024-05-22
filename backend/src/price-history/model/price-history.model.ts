import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';
import { Project } from 'src/project/model/project.model';

@ObjectType()
export class PriceHistory extends BaseModel {
  @Field({ nullable: true })
  productVariantId?: string;

  @Field(() => ProductVariant, { nullable: true })
  productVariant?: ProductVariant;

  @Field({ nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  project?: Project;

  @Field({ nullable: true })
  price?: number;
}
