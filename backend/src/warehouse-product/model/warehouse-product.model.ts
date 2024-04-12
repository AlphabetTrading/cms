import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';
import { WarehouseStore } from 'src/warehouse-store/model/warehouse-store.model';

@ObjectType()
export class WarehouseProduct extends BaseModel {
  @Field({ nullable: true })
  productVariantId?: string;

  @Field(() => ProductVariant, { nullable: true })
  productVariant?: ProductVariant;

  @Field({ nullable: true })
  warehouseId?: string;

  @Field(() => WarehouseStore, { nullable: true })
  warehouse?: WarehouseStore;

  @Field(() => Number, { nullable: true })
  quantity?: number;
}
