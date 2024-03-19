import { Field, InputType, registerEnumType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';

registerEnumType(ApprovalStatus, {
  name: 'ApprovalStatus',
  description: 'Possible options for Approval Status',
});
@InputType()
export class FilterMaterialRequestInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => DateTimeFilter, { nullable: true })
  date?: DateTimeFilter;

  @Field(() => StringFilter, { nullable: true })
  from?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  to?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  requestedById?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  approvedById?: StringFilter;

  @Field({ nullable: true })
  status?: ApprovalStatus;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
