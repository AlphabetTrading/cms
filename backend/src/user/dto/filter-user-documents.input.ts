import { Field, InputType } from '@nestjs/graphql';
import { Prisma, UserRole } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';
import { FilterCompanyInput } from 'src/company/dto/filter-company.input';

@InputType()
export class FilterUserDocumentsInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => StringFilter, { nullable: true })
  fullName?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  email?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  phoneNumber?: StringFilter;

  @Field(() => [UserRole], { nullable: true })
  role?: UserRole[];

  @Field({ nullable: true })
  companyId?: string;

  @Field(() => FilterCompanyInput, { nullable: true })
  company?: Prisma.CompanyWhereInput;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
