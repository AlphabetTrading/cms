import { Field, Int, ObjectType } from '@nestjs/graphql';
import { DailySiteData } from 'src/daily-site-data/model/daily-site-data.model';
import { DailyStockBalance } from 'src/daily-stock-balance/model/daily-stock-balance.model';
import { MaterialIssueVoucher } from 'src/material-issue/model/material-issue.model';
import { MaterialReceiveVoucher } from 'src/material-receive/model/material-receive.model';
import { MaterialRequestVoucher } from 'src/material-request/model/material-request.model';
import { MaterialReturnVoucher } from 'src/material-return/model/material-return.model';
import { MaterialTransferVoucher } from 'src/material-transfer/model/material-transfer.model';
import { Milestone } from 'src/milestone/model/milestone.model';
import { PriceHistory } from 'src/price-history/model/price-history.model';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';
import { Product } from 'src/product/model/product.model';
import { Proforma } from 'src/proforma/model/proforma.model';
import { Project } from 'src/project/model/project.model';
import { PurchaseOrderVoucher } from 'src/purchase-order/model/purchase-order.model';
import { Task } from 'src/task/model/task.model';
import { User } from 'src/user/user.model';
import { WarehouseProduct } from 'src/warehouse-product/model/warehouse-product.model';
import { WarehouseStore } from 'src/warehouse-store/model/warehouse-store.model';

@ObjectType()
export class PaginationInfo {
  @Field(() => Int, { nullable: true, defaultValue: 10 })
  limit?: number;

  @Field(() => Int, { nullable: true, defaultValue: 0 })
  page?: number;

  @Field(() => Int, { nullable: true })
  count?: number;
}

@ObjectType()
export class PaginationDailySiteData {
  @Field(() => [DailySiteData])
  items: DailySiteData[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationDailyStockBalances {
  @Field(() => [DailyStockBalance])
  items: DailyStockBalance[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationProductVariants {
  @Field(() => [ProductVariant])
  items: ProductVariant[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationPriceHistories {
  @Field(() => [PriceHistory])
  items: PriceHistory[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationProducts {
  @Field(() => [Product])
  items: Product[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationWarehouseStores {
  @Field(() => [WarehouseStore])
  items: WarehouseStore[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationWarehouseProducts {
  @Field(() => [WarehouseProduct])
  items: WarehouseProduct[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
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
export class PaginationMaterialTransfers {
  @Field(() => [MaterialTransferVoucher])
  items: MaterialTransferVoucher[];

  @Field(() => PaginationInfo, { nullable: true })
  meta?: PaginationInfo;
}

@ObjectType()
export class PaginationProformas {
  @Field(() => [Proforma])
  items: Proforma[];

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
