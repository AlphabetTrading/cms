import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { Company } from 'src/company/model/company.model';
import { WarehouseStoreManager } from './warehouse-store-manager.model';

@ObjectType()
export class WarehouseStore extends BaseModel {
  @Field({ nullable: true })
  name?: string;

  @Field({ nullable: true })
  location?: string;

  @Field({ nullable: true })
  companyId?: string;

  @Field(() => Company, { nullable: true })
  company?: Company;

  @Field(() => [WarehouseStoreManager], { nullable: true })
  warehouseStoreManagers?: WarehouseStoreManager[];
}
