import { Field, InputType } from '@nestjs/graphql';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { registerEnumType } from '@nestjs/graphql';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { FilterProjectInput } from 'src/project/dto/filter-project.input';

registerEnumType(ApprovalStatus, {
  name: 'ApprovalStatus',
  description: 'Possible options for Approval Status',
});

@InputType()
export class FilterDailyStockBalanceInput {
  @Field({ nullable: true })
  id?: string;

  @Field({ nullable: true })
  projectId?: string;

  @Field(() => FilterProjectInput, { nullable: true })
  project?: Prisma.ProjectWhereInput;

  // @Field({ nullable: true })
  // warehouseStoreId?: string;

  // @Field(() => FilterWarehouseStoreInput, { nullable: true })
  // warehouseStore?: Prisma.WarehouseStoreWhereInput;

  // @Field({ nullable: true })
  // productVariantId?: string;

  // @Field(() => FilterProductVariantInput, { nullable: true })
  // productVariant?: Prisma.ProductVariantWhereInput;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;

  @Field(() => DateTimeFilter, { nullable: true })
  updatedAt?: DateTimeFilter;
}
