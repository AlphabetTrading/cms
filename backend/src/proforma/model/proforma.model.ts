import { Field, ObjectType } from '@nestjs/graphql';
import { ApprovalStatus } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { MaterialRequestItem } from 'src/material-request/model/material-request.model';
import { Project } from 'src/project/model/project.model';
import { User } from 'src/user/user.model';

@ObjectType()
export class ProformaItem extends BaseModel {
  @Field(() => String, { nullable: true })
  vendor?: string;

  @Field(() => Number, { nullable: true })
  quantity?: number;

  @Field(() => Number, { nullable: true })
  unitPrice?: number;

  @Field(() => Number, { nullable: true })
  totalPrice?: number;

  @Field(() => String, { nullable: true })
  remark?: string;

  @Field(() => String, { nullable: true })
  photo?: string;
}

@ObjectType()
export class Proforma extends BaseModel {
  @Field(() => String, { nullable: true })
  projectId?: string;

  @Field(() => Project, { nullable: true })
  Project?: Project;

  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String, { nullable: true })
  materialRequestItemId?: string;

  @Field(() => MaterialRequestItem, { nullable: true })
  materialRequestItem?: MaterialRequestItem;

  @Field(() => [ProformaItem], { nullable: true })
  items?: ProformaItem[];

  @Field(() => String, { nullable: true })
  preparedById?: string;

  @Field(() => User, { nullable: true })
  preparedBy?: User;

  @Field(() => String, { nullable: true })
  approvedById?: string;

  @Field(() => User, { nullable: true })
  approvedBy?: User;

  @Field(() => String, { nullable: true })
  selectedProformaItemId?: string;

  @Field(() => ProformaItem, { nullable: true })
  selectedProformaItem?: ProformaItem;

  @Field(() => ApprovalStatus, {
    defaultValue: ApprovalStatus.PENDING,
    nullable: true,
  })
  status?: ApprovalStatus;
}