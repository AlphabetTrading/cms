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

  @Field(() => String)
  receivingStore?: string;

  @Field(() => [MaterialReturnItem])
  items?: MaterialReturnItem[];

  @Field(() => String)
  returnedById?: string;

  @Field(() => UserModel, { nullable: true })
  returnedBy?: User;

  @Field(() => String)
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

  @Field(() => String)
  issueVoucherId?: string;

  @Field(() => String)
  unitOfMeasure?: string;

  @Field(() => Number)
  quantityReturned?: number;

  @Field(() => Number)
  unitCost?: number;

  @Field(() => Number)
  totalCost?: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String)
  materialReturnVoucherId?: string;
}
