import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class CreateWarehouseStoreInput {
  @Field()
  name: string;

  @Field()
  location: string;

  @Field()
  companyId: string;
}
