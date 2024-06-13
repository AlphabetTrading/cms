import { Field, InputType } from '@nestjs/graphql';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { FilterUserDocumentsInput } from 'src/user/dto/filter-user-documents.input';
import { FilterProjectInput } from 'src/project/dto/filter-project.input';

@InputType()
export class FilterDailySiteDataInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => DateTimeFilter, { nullable: true })
  date?: DateTimeFilter;

  @Field({ nullable: true })
  projectId?: string;

  @Field(() => FilterProjectInput, { nullable: true })
  project?: Prisma.ProjectWhereInput;

  @Field({ nullable: true })
  contractor?: StringFilter;

  @Field(() => String, { nullable: true })
  preparedById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  preparedBy?: Prisma.UserWhereInput;

  @Field(() => String, { nullable: true })
  checkedById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  checkedBy?: Prisma.UserWhereInput;

  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  approvedBy?: Prisma.UserWhereInput;

  @Field(() => [ApprovalStatus], { nullable: true })
  status?: ApprovalStatus[];

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
