import { ObjectType, Field } from '@nestjs/graphql';

@ObjectType()
export class WarehouseStore {
  @Field()
  name?: string;

  @Field()
  location?: string;
}
