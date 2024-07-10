import { Field, InputType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { FilterProjectInput } from 'src/project/dto/filter-project.input';

@InputType()
export class FilterProformaInput {
  @Field({ nullable: true })
  id?: string;

  @Field({ nullable: true })
  projectId?: string;

  @Field(()=> FilterProjectInput, { nullable: true })
  project?: Prisma.ProjectWhereInput;

  @Field(() => String, { nullable: true })
  materialRequestItemId?: string;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  updatedAt?: DateTimeFilter;
}
