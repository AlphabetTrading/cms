import { Field, InputType } from '@nestjs/graphql';
import { Prisma, SubStructureUseDescription, SuperStructureUseDescription, UseType } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { FilterProductVariantInput } from 'src/product-variant/dto/filter-product-variant.input';

@InputType()
export class FilterProductUseInput {
  @Field({ nullable: true })
  id?: string;

  @Field({ nullable: true })
  productVariantId?: string;

  @Field(() => FilterProductVariantInput, { nullable: true })
  productVariant?: Prisma.ProductVariantWhereInput;

  @Field({ nullable: true })
  useType?: UseType;

  @Field({ nullable: true })
  subStructureDescription?: SubStructureUseDescription;

  @Field({ nullable: true })
  superStructureDescription?: SuperStructureUseDescription;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
