import { Field, InputType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { FilterProductVariantInput } from 'src/product-variant/dto/filter-product-variant.input';
import { FilterProjectInput } from 'src/project/dto/filter-project.input';
import { FilterWarehouseStoreInput } from 'src/warehouse-store/dto/filter-warehouse-store.input';

@InputType()
export class FilterWarehouseProductInput {
  @Field({ nullable: true })
  id?: string;

  @Field({ nullable: true })
  projectId?: string;

  @Field(() => FilterProjectInput, { nullable: true })
  project?: Prisma.ProjectWhereInput;

  @Field({ nullable: true })
  productVariantId?: string;

  @Field(() => FilterProductVariantInput, { nullable: true })
  productVariant?: Prisma.ProductVariantWhereInput;

  @Field({ nullable: true })
  warehouseId?: string
  
  @Field(() => FilterWarehouseStoreInput, { nullable: true })
  warehouse?: Prisma.WarehouseStoreWhereInput;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
