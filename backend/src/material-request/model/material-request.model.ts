import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus, Project, User } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { User as UserModel } from 'src/user/user.model';
import { Project as ProjectModel } from 'src/project/model/project.model';

@ObjectType()
export class MaterialRequestVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => ProjectModel, { nullable: true })
  project?: Project;

  @Field(() => [MaterialRequestItem], { nullable: true })
  items?: MaterialRequestItem[];

  @Field(() => String, { nullable: true })
  requestedById?: string;

  @Field(() => UserModel, { nullable: true })
  requestedBy?: User;

  @Field(() => String, { nullable: true })
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
  productId?: string;

  @Field(() => String, { nullable: true })
  unitOfMeasure?: string;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  inStockQuantity?: number;

  @Field(() => Number, { nullable: true })
  toBePurchasedQuantity?: number;

  @Field(() => String, { nullable: true })
  remark?: string;
}
