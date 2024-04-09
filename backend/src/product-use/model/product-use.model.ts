import { ObjectType, Field } from '@nestjs/graphql';
import {
  ProductVariant,
  SubStructureUseDescription,
  SuperStructureUseDescription,
  UseType,
} from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { ProductVariant as ProductVariantModel } from 'src/product-variant/model/product-variant.model';

@ObjectType()
export class ProductUse extends BaseModel {
  @Field(() => String, { nullable: true })
  productVariantId?: string;

  @Field(() => ProductVariantModel, { nullable: true })
  productVariant?: ProductVariant;

  @Field(() => UseType, { nullable: true })
  useType?: UseType;

  @Field(() => SubStructureUseDescription, { nullable: true })
  subStructureDescription?: SubStructureUseDescription;

  @Field(() => SuperStructureUseDescription, { nullable: true })
  superStructureDescription?: SuperStructureUseDescription;
}
