import { Field, InputType } from '@nestjs/graphql';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { NumberFilter } from 'src/common/filter/number-filter';
import { StringFilter } from 'src/common/filter/string-filter';

@InputType()
export class FilterPurchaseOrderInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => DateTimeFilter, { nullable: true })
  dateOfReceiving?: DateTimeFilter;

  @Field(() => StringFilter, { nullable: true })
  purchaseNumber?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  supplierName?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  materialRequestId?: StringFilter;

  @Field(() => NumberFilter, { nullable: true })
  subTotal?: NumberFilter;

  @Field(() => StringFilter, { nullable: true })
  preparedById?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  approvedById?: StringFilter;

  @Field({ nullable: true })
  approved?: boolean;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
