import { ObjectType, Field } from '@nestjs/graphql';
import { Product, WarehouseStore } from '@prisma/client';
import { Product as ProductModel } from 'src/product/model/product.model';
import { WarehouseStore as WarehouseStoreModel } from 'src/warehouse-store/model/warehouse-store.model';

@ObjectType()
export class WarehouseProduct {
  @Field()
  productId?: string;

  @Field(() => ProductModel)
  product?: Product;

  @Field({ nullable: true })
  warehouseId?: string;

  @Field(() => WarehouseStoreModel)
  warehouse?: WarehouseStore;

  @Field(() => Number)
  quantity?: number;
}
