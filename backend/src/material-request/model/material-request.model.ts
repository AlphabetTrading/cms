import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';
import { Proforma } from 'src/proforma/model/proforma.model';
import { Project } from 'src/project/model/project.model';
import { User } from 'src/user/user.model';

@ObjectType()
export class MaterialRequestVoucher extends BaseModel {
  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  Project?: Project;

  @Field(() => [MaterialRequestItem], { nullable: true })
  items?: MaterialRequestItem[];

  @Field(() => String, { nullable: true })
  requestedById?: string;

  @Field(() => User, { nullable: true })
  requestedBy?: User;

  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => User, { nullable: true })
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
  productVariantId?: string;

  @Field(() => ProductVariant, { nullable: true })
  productVariant?: ProductVariant;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => [Proforma], { nullable: true })
  proformas?: Proforma[] 
}
