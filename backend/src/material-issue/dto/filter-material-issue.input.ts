import { Field, InputType } from '@nestjs/graphql';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';
import { registerEnumType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';

registerEnumType(ApprovalStatus, {
  name: 'ApprovalStatus',
  description: 'Possible options for Approval Status',
});

@InputType()
export class FilterMaterialIssueInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => DateTimeFilter, { nullable: true })
  date?: DateTimeFilter;

  @Field(() => StringFilter, { nullable: true })
  issuedToId?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  preparedById?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  approvedById?: StringFilter;

  @Field({ nullable: true })
  status?: ApprovalStatus;

  @Field(() => StringFilter, { nullable: true })
  receivedById?: StringFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
