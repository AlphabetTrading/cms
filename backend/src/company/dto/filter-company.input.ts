import { Field, InputType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';
import { FilterUserDocumentsInput } from 'src/user/dto/filter-user-documents.input';

@InputType()
export class FilterCompanyInput {
  @Field({ nullable: true })
  id?: string;

  @Field({ nullable: true })
  ownerId?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  owner?: Prisma.UserWhereInput;

  @Field(() => StringFilter, { nullable: true })
  name?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  address?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  contactInfo?: StringFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
