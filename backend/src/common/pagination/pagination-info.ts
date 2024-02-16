import { Field, Int, ObjectType } from '@nestjs/graphql';
import { MaterialIssueVoucher } from 'src/material-issue/model/material-issue.model';
import { MaterialReceiveVoucher } from 'src/material-receive/model/material-receive.model';
import { MaterialRequestVoucher } from 'src/material-request/model/material-request.model';
import { MaterialReturnVoucher } from 'src/material-return/model/material-return.model';
import { Milestone } from 'src/milestone/model/milestone.model';
import { Project } from 'src/project/model/project.model';
import { PurchaseOrderVoucher } from 'src/purchase-order/model/purchase-order.model';
import { Task } from 'src/task/model/task.model';
import { User } from 'src/user/user.model';

@ObjectType()
export class PaginationInfo {
  @Field(() => Int, { nullable: true })
  limit?: number;

  @Field(() => Int, { nullable: true })
  page?: number;

  @Field(() => Int, { nullable: true })
  count?: number;
}

@ObjectType()
export class PaginationMaterialIssues {
  @Field(() => [MaterialIssueVoucher])
  items: MaterialIssueVoucher[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationMaterialRequests {
  @Field(() => [MaterialRequestVoucher])
  items: MaterialRequestVoucher[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationMaterialReturns {
  @Field(() => [MaterialReturnVoucher])
  items: MaterialReturnVoucher[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationMaterialReceives {
  @Field(() => [MaterialReceiveVoucher])
  items: MaterialReceiveVoucher[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationPurchaseOrders {
  @Field(() => [PurchaseOrderVoucher])
  items: PurchaseOrderVoucher[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationProjects {
  @Field(() => [Project])
  items: Project[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationMilestones {
  @Field(() => [Milestone])
  items: Milestone[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationTasks {
  @Field(() => [Task])
  items: Task[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationUsers {
  @Field(() => [User])
  items: User[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}
