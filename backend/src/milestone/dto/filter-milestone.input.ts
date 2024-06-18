import { Field, InputType } from '@nestjs/graphql';
import { Prisma, UseType } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';
import { FilterProjectInput } from 'src/project/dto/filter-project.input';
import { FilterUserDocumentsInput } from 'src/user/dto/filter-user-documents.input';

@InputType()
export class FilterMilestoneInput {
  @Field(() => String, { nullable: true })
  id?: string;

  @Field(() => StringFilter, { nullable: true })
  name?: StringFilter;

  @Field(() => UseType, { nullable: true })
  stage?: UseType;

  @Field(() => DateTimeFilter, { nullable: true })
  dueDate?: DateTimeFilter;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => FilterProjectInput, { nullable: true })
  project?: Prisma.ProjectWhereInput;

  @Field(() => String, { nullable: true })
  createdById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  createdBy?: Prisma.UserWhereInput;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
