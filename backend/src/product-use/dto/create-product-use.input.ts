import { InputType, Field } from '@nestjs/graphql';
import {
  SubStructureUseDescription,
  SuperStructureUseDescription,
  UseType,
} from '@prisma/client';

@InputType()
export class CreateProductUseInput {
  @Field(() => String)
  productVariantId: string;

  @Field(() => UseType)
  useType: UseType;

  @Field(() => SubStructureUseDescription, { nullable: true })
  subStructureDescription?: SubStructureUseDescription;

  @Field(() => SuperStructureUseDescription, { nullable: true })
  superStructureDescription?: SuperStructureUseDescription;
}
