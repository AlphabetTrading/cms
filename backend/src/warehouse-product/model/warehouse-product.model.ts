import { ObjectType, Field } from '@nestjs/graphql';
import { ProductVariant, WarehouseStore } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { ProductVariant as ProductVariantModel } from 'src/product-variant/model/product-variant.model';
import { WarehouseStore as WarehouseStoreModel } from 'src/warehouse-store/model/warehouse-store.model';

@ObjectType()
export class WarehouseProduct extends BaseModel {
  @Field({ nullable: true })
  productId?: string;

  @Field(() => ProductVariantModel, { nullable: true })
  product?: ProductVariant;

  @Field({ nullable: true })
  warehouseId?: string;

  @Field(() => WarehouseStoreModel, { nullable: true })
  warehouse?: WarehouseStore;

  @Field(() => Number, { nullable: true })
  quantity?: number;
}
