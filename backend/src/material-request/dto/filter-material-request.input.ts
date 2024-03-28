import { Field, InputType, registerEnumType } from '@nestjs/graphql';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';
import { FilterUserDocumentsInput } from 'src/user/dto/filter-user-documents.input';

registerEnumType(ApprovalStatus, {
  name: 'ApprovalStatus',
  description: 'Possible options for Approval Status',
});
@InputType()
export class FilterMaterialRequestInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => StringFilter, { nullable: true })
  serialNumber?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  from?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  to?: StringFilter;

  @Field(() => String, { nullable: true })
  requestedById?: string;

  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  requestedBy?: Prisma.UserWhereInput;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  approvedBy?: Prisma.UserWhereInput;

  @Field({ nullable: true })
  status?: ApprovalStatus;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
