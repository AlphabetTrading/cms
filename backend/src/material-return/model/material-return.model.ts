import { Field, ID, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class MaterialReturnVoucher extends BaseModel {
  @Field(() => Date)
  date: Date;

  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String)
  from: string;

  @Field(() => String)
  receivingStore: string;

  @Field(() => [MaterialReturnItem])
  items: MaterialReturnItem[];

  @Field(() => String)
  returnedById: string;

  @Field(() => String)
  receivedById: string;

  @Field(() => ApprovalStatus, {
    defaultValue: ApprovalStatus.PENDING,
    nullable: true,
  })
  approved?: ApprovalStatus;
}

@ObjectType()
export class MaterialReturnItem {
  @Field(() => ID)
  id: string;

  @Field(() => Number)
  listNo: number;

  @Field(() => String, { nullable: true })
  description?: string;

  @Field(() => String)
  issueVoucherId: string;

  @Field(() => String)
  unitOfMeasure: string;

  @Field(() => Number)
  quantityReturned: number;

  @Field(() => Number)
  unitCost: number;

  @Field(() => Number)
  totalCost: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String)
  materialReturnVoucherId: string;
}
