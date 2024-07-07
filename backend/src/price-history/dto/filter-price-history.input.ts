import { Field, InputType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { FilterCompanyInput } from 'src/company/dto/filter-company.input';
import { FilterProductVariantInput } from 'src/product-variant/dto/filter-product-variant.input';

@InputType()
export class FilterPriceHistoryInput {
  @Field({ nullable: true })
  id?: string;

  @Field()
  companyId: string;

  @Field(() => FilterCompanyInput, { nullable: true })
  company?: Prisma.CompanyWhereInput;

  @Field({ nullable: true })
  productVariantId?: string;

  @Field(() => FilterProductVariantInput, { nullable: true })
  productVariant?: Prisma.ProductVariantWhereInput;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
