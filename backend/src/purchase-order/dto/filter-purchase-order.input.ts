import { Field, InputType, registerEnumType } from '@nestjs/graphql';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { NumberFilter } from 'src/common/filter/number-filter';
import { StringFilter } from 'src/common/filter/string-filter';
import { FilterProjectInput } from 'src/project/dto/filter-project.input';
import { FilterUserDocumentsInput } from 'src/user/dto/filter-user-documents.input';

registerEnumType(ApprovalStatus, {
  name: 'ApprovalStatus',
  description: 'Possible options for Approval Status',
});

@InputType()
export class FilterPurchaseOrderInput {
  @Field({ nullable: true })
  id?: string;

  @Field({ nullable: true })
  projectId?: string;

  @Field(() => FilterProjectInput, { nullable: true })
  project?: Prisma.ProjectWhereInput;

  @Field(() => StringFilter, { nullable: true })
  serialNumber?: StringFilter;

  @Field(() => NumberFilter, { nullable: true })
  subTotal?: NumberFilter;

  @Field(() => String, { nullable: true })
  preparedById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  preparedBy?: Prisma.UserWhereInput;

  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  approvedBy?: Prisma.UserWhereInput;

  @Field(() => [ApprovalStatus], { nullable: true })
  status?: ApprovalStatus[];

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
