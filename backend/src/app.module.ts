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
  ],
})
export class AppModule {}
