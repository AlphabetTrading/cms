import { Field, InputType } from '@nestjs/graphql';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { StringFilter } from 'src/common/filter/string-filter';
import { registerEnumType } from '@nestjs/graphql';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { FilterUserDocumentsInput } from 'src/user/dto/filter-user-documents.input';
import { FilterProjectInput } from 'src/project/dto/filter-project.input';
import { FilterWarehouseStoreInput } from 'src/warehouse-store/dto/filter-warehouse-store.input';

registerEnumType(ApprovalStatus, {
  name: 'ApprovalStatus',
  description: 'Possible options for Approval Status',
});

@InputType()
export class FilterMaterialIssueInput {
  @Field({ nullable: true })
  id?: string;

  @Field({ nullable: true })
  projectId?: string;

  @Field(()=> FilterProjectInput, { nullable: true })
  project?: Prisma.ProjectWhereInput;

  @Field({ nullable: true })
  warehouseStoreId?: string;

  @Field(()=> FilterWarehouseStoreInput, { nullable: true })
  warehouseStore?: Prisma.WarehouseStoreWhereInput;

  @Field(() => StringFilter, { nullable: true })
  serialNumber?: StringFilter;

  @Field(() => String, { nullable: true })
  preparedById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  preparedBy?: Prisma.UserWhereInput;

  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => FilterUserDocumentsInput, { nullable: true })
  approvedBy?: Prisma.UserWhereInput;

  @Field({ nullable: true })
  status?: ApprovalStatus;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
