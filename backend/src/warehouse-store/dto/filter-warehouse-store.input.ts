import { Field, InputType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';
import { FilterCompanyInput } from 'src/company/dto/filter-company.input';

@InputType()
export class FilterWarehouseStoreInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => StringFilter, { nullable: true })
  name?: StringFilter;

  @Field( { nullable: true })
  companyId?: string;

  @Field(() => FilterCompanyInput, { nullable: true })
  company?: Prisma.CompanyWhereInput;

  @Field(() => StringFilter, { nullable: true })
  location?: StringFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
