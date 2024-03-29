import { Field, InputType } from '@nestjs/graphql';
import { Prisma } from '@prisma/client';
import { DateTimeFilter } from 'src/common/filter/date-filter';
import { FilterProductInput } from 'src/product/dto/filter-product.input';
import { FilterWarehouseStoreInput } from 'src/warehouse-store/dto/filter-warehouse-store.input';

@InputType()
export class FilterWarehouseProductInput {
  @Field({ nullable: true })
  id?: string;

  @Field({ nullable: true })
  productId?: string;

  @Field(() => FilterProductInput, { nullable: true })
  product?: Prisma.ProductWhereInput;

  @Field({ nullable: true })
  warehouseId?: string
  
  @Field(() => FilterWarehouseStoreInput, { nullable: true })
  warehouse?: Prisma.WarehouseStoreWhereInput;

  @Field(() => DateTimeFilter, { nullable: true })
  createdAt?: DateTimeFilter;
}
