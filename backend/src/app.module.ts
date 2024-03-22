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
import { PurchaseOrderModule } from './purchase-order/purchase-order.module';
import { PrismaModule } from './prisma.module';
import { ApolloServerPluginLandingPageLocalDefault } from '@apollo/server/plugin/landingPage/default';
import { MilestoneModule } from './milestone/milestone.module';
import { ProjectModule } from './project/project.module';
import { TaskModule } from './task/task.module';
import { DocumentTransactionModule } from './document-transaction/document-transaction.module';
<<<<<<< HEAD
=======
import { ProformaModule } from './proforma/proforma.module';
>>>>>>> 64f8cd9f87e53c2f0541824ea45f67370ec70acb
import { StorageModule } from './storage/storage.module';

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
    ConfigModule,
    AuthModule,
    UserModule,
    PrismaModule,
    MaterialIssueModule,
    MaterialReturnModule,
    MaterialReceiveModule,
    MaterialRequestModule,
    PurchaseOrderModule,
    MilestoneModule,
    ProjectModule,
    TaskModule,
    DocumentTransactionModule,
    StorageModule,
  ],
})
export class AppModule {}
