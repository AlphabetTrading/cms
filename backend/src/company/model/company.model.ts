import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { Project } from 'src/project/model/project.model';
import { User } from 'src/user/user.model';
import { WarehouseStore } from 'src/warehouse-store/model/warehouse-store.model';

@ObjectType()
export class Company extends BaseModel {
  @Field(() => String, { nullable: true })
  name?: string;

  @Field(() => String, { nullable: true })
  address?: string;

  @Field(() => String, { nullable: true })
  contactInfo?: string;

  @Field(() => String, { nullable: true })
  ownerId?: string;

  @Field(() => User, { nullable: true })
  owner?: User;

  @Field(() => [User], { nullable: true })
  employees?: User[];

  @Field(() => [WarehouseStore], { nullable: true })
  warehouseStores?: WarehouseStore[];

  @Field(() => [Project], { nullable: true })
  projects?: Project[];
}
