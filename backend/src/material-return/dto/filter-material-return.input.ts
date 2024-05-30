import { Field, InputType, registerEnumType } from '@nestjs/graphql';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';
import { FilterProjectInput } from 'src/project/dto/filter-project.input';
import { FilterUserDocumentsInput } from 'src/user/dto/filter-user-documents.input';
import { FilterWarehouseProductInput } from 'src/warehouse-product/dto/filter-warehouse-product.input';

registerEnumType(ApprovalStatus, {
  name: 'ApprovalStatus',
  description: 'Possible options for Approval Status',
});

@InputType()
export class FilterMaterialReturnInput {
  @Field({ nullable: true })
  id?: string;

  @Field({ nullable: true })
  projectId?: string;

  @Field(() => FilterProjectInput, { nullable: true })
  project?: Prisma.ProjectWhereInput;

  @Field(() => StringFilter, { nullable: true })
  serialNumber?: StringFilter;

  @Field({ nullable: true })
  receivingWarehouseStoreId?: string;

  @Field(() => FilterWarehouseProductInput, { nullable: true })
  receivingWarehouseStore?: Prisma.WarehouseStoreWhereInput;

  @Field(() => String, { nullable: true })
  returnedById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  returnedBy?: Prisma.UserWhereInput;

  @Field(() => String, { nullable: true })
  receivedById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  receivedBy?: Prisma.UserWhereInput;

  @Field(() => ApprovalStatus, { nullable: true })
  status?: ApprovalStatus[];

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
