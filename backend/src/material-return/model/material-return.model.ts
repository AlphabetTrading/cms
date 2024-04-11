import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus, Project, User } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { User as UserModel } from 'src/user/user.model';
import { Project as ProjectModel } from 'src/project/model/project.model';

@ObjectType()
export class MaterialReturnVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => ProjectModel, { nullable: true })
  project?: Project;

  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  receivingStore?: string;

  @Field(() => [MaterialReturnItem])
  items?: MaterialReturnItem[];

  @Field(() => String, { nullable: true })
  returnedById?: string;

  @Field(() => UserModel, { nullable: true })
  returnedBy?: User;

  @Field(() => String, { nullable: true })
  receivedById?: string;

  @Field(() => UserModel, { nullable: true })
  receivedBy?: User;

  @Field(() => ApprovalStatus, {
    defaultValue: ApprovalStatus.PENDING,
    nullable: true,
  })
  status?: ApprovalStatus;
}

@ObjectType()
export class MaterialReturnItem extends BaseModel {
  @Field(() => String, { nullable: true })
  productId?: string;

  @Field(() => String, { nullable: true })
  issueVoucherId?: string;

  @Field(() => Number, { nullable: true })
  quantityReturned?: number;

  @Field(() => Number, { nullable: true })
  unitCost?: number;

  @Field(() => Number, { nullable: true })
  totalCost?: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String, { nullable: true })
  materialReturnVoucherId?: string;
}
