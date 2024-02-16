import { Field, InputType } from '@nestjs/graphql';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';

@InputType()
export class FilterMaterialReceiveInput {
  @Field({ nullable: true })
  id?: string;

  @Field(() => DateTimeFilter, { nullable: true })
  date?: DateTimeFilter;

  @Field(() => StringFilter, { nullable: true })
  supplierName?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  materialRequestId?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  invoiceId?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  purchasedById?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  purchaseOrderId?: StringFilter;

  @Field(() => StringFilter, { nullable: true })
  approvedById?: StringFilter;

  @Field(() => Boolean, { nullable: true })
  approved?: boolean;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}