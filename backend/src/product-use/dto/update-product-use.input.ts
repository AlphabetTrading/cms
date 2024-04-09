import {
  UseType,
  SubStructureUseDescription,
  SuperStructureUseDescription,
} from '@prisma/client';
import { CreateProductUseInput } from './create-product-use.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateProductUseInput extends PartialType(CreateProductUseInput) {
  @Field(() => String)
  productVariantId: string;

  @Field(() => UseType)
  useType: UseType;

  @Field(() => SubStructureUseDescription, { nullable: true })
  subStructureDescription?: SubStructureUseDescription;

  @Field(() => SuperStructureUseDescription, { nullable: true })
  superStructureDescription?: SuperStructureUseDescription;
}
