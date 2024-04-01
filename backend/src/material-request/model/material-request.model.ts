import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus, User } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { User as UserModel } from 'src/user/user.model';

@ObjectType()
export class MaterialRequestVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => [MaterialRequestItem])
  items?: MaterialRequestItem[];

  @Field(() => String)
  requestedById?: string;

  @Field(() => UserModel, { nullable: true })
  requestedBy?: User;

  @Field(() => String)
  approvedById?: string;

  @Field(() => UserModel, { nullable: true })
  approvedBy?: User;

  @Field(() => ApprovalStatus, {
    defaultValue: ApprovalStatus.PENDING,
    nullable: true,
  })
  status?: ApprovalStatus;
}

@ObjectType()
export class MaterialRequestItem extends BaseModel {
  @Field(() => String, { nullable: true })
  description?: string;

  @Field(() => String)
  unitOfMeasure?: string;

  @Field(() => Number)
  quantity?: number;

  @Field(() => Number, { nullable: true })
  inStockQuantity?: number;

  @Field(() => Number, { nullable: true })
  toBePurchasedQuantity?: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String)
  materialRequestVoucherId?: string;
}
