import { Module } from '@nestjs/common';
import { GraphQLModule } from '@nestjs/graphql';
import { ApolloDriver, ApolloDriverConfig } from '@nestjs/apollo';
import { join } from 'path';
import { AuthModule } from './auth/auth.module';
import { UserModule } from './user/user.module';
import { ConfigModule } from './config/config.module';
import { MaterialIssueModule } from './material-issue/material-issue.module';
import { MaterialReturnModule } from './material-return/material-return.module';
import { MaterialReceiveModule } from './material-receive/material-receive.module';
import { MaterialRequestModule } from './material-request/material-request.module';
import { MaterialTransferModule } from './material-transfer/material-transfer.module';
import { PurchaseOrderModule } from './purchase-order/purchase-order.module';
import { PrismaModule } from './prisma.module';
import { ApolloServerPluginLandingPageLocalDefault } from '@apollo/server/plugin/landingPage/default';
import { MilestoneModule } from './milestone/milestone.module';
import { ProjectModule } from './project/project.module';
import { TaskModule } from './task/task.module';
import { DocumentTransactionModule } from './document-transaction/document-transaction.module';
import { StorageModule } from './storage/storage.module';
import { ProformaModule } from './proforma/proforma.module';
import { WarehouseStoreModule } from './warehouse-store/warehouse-store.module';
import { ProductModule } from './product/product.module';
import { WarehouseProductModule } from './warehouse-product/warehouse-product.module';
import { PriceHistoryModule } from './price-history/price-history.module';
import { ProductVariantModule } from './product-variant/product-variant.module';
import { DailySiteDataModule } from './daily-site-data/daily-site-data.module';
import { DailyStockBalanceModule } from './daily-stock-balance/daily-stock-balance.module';
import { ScheduleModule } from '@nestjs/schedule';
import { CompanyModule } from './company/company.module';
import { StatModule } from './stat/stat.module';

@Module({
  imports: [
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      autoSchemaFile: join(process.cwd(), 'src/schema.gql'),
      sortSchema: true,
      playground: false,
      plugins: [ApolloServerPluginLandingPageLocalDefault()],
      context: ({ req, res }) => ({
        req,
        res,
      }),
    }),
    ScheduleModule.forRoot(),
    ConfigModule,
    AuthModule,
    UserModule,
    PrismaModule,
    MaterialIssueModule,
    MaterialReturnModule,
    MaterialReceiveModule,
    MaterialRequestModule,
    MaterialTransferModule,
    PurchaseOrderModule,
    MilestoneModule,
    ProjectModule,
    TaskModule,
    DocumentTransactionModule,
    ProformaModule,
    StorageModule,
    WarehouseStoreModule,
    ProductModule,
    WarehouseProductModule,
    PriceHistoryModule,
    ProductVariantModule,
    DailyStockBalanceModule,
    DailySiteDataModule,
    CompanyModule,
    StatModule,
  ],
})
export class AppModule {}
