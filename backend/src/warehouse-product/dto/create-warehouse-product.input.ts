import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class CreateWarehouseProductInput {
  @Field()
  productVariantId: string

  @Field({ nullable: true })
  warehouseId: string
  
  @Field({ nullable: true })
  quantity: number
}