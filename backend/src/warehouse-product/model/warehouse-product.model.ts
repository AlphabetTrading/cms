import { ObjectType, Field } from '@nestjs/graphql';
import { Product, WarehouseStore } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { Product as ProductModel } from 'src/product/model/product.model';
import { WarehouseStore as WarehouseStoreModel } from 'src/warehouse-store/model/warehouse-store.model';

@ObjectType()
export class WarehouseProduct extends BaseModel{
  @Field({ nullable: true })
  productId?: string;

  @Field(() => ProductModel, { nullable: true })
  product?: Product;

  @Field({ nullable: true })
  warehouseId?: string;

  @Field(() => WarehouseStoreModel, { nullable: true })
  warehouse?: WarehouseStore;

  @Field(() => Number, { nullable: true })
  quantity?: number;
}
