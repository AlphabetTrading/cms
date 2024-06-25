import { Field, InputType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { NumberFilter } from 'src/common/filter/number-filter';
import { StringFilter } from 'src/common/filter/string-filter';
import { FilterCompanyInput } from 'src/company/dto/filter-company.input';

@InputType()
export class FilterProjectInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => StringFilter, { nullable: true })
  name?: StringFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  startDate?: DateTimeFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  endDate?: DateTimeFilter;

  @Field(() => NumberFilter, { nullable: true })
  budget?: NumberFilter;

  @Field(() => String, { nullable: true })
  companyId?: string;

  @Field(() => FilterCompanyInput, { nullable: true })
  company?: Prisma.CompanyWhereInput;

  @Field(() => StringFilter, { nullable: true })
  status?: StringFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
