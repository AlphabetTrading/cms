import { Module } from '@nestjs/common';
import { DocumentTransactionService } from './document-transaction.service';
import { DocumentTransactionResolver } from './document-transaction.resolver';
import { MaterialReceiveModule } from 'src/material-receive/material-receive.module';
import { MaterialIssueModule } from 'src/material-issue/material-issue.module';
import { MaterialRequestModule } from 'src/material-request/material-request.module';
import { MaterialReturnModule } from 'src/material-return/material-return.module';
import { PurchaseOrderModule } from 'src/purchase-order/purchase-order.module';

@Module({
  imports: [
    MaterialReceiveModule,
    MaterialIssueModule,
    MaterialReturnModule,
    MaterialRequestModule,
    PurchaseOrderModule,
  ],
  providers: [DocumentTransactionResolver, DocumentTransactionService],
  exports: [DocumentTransactionService],
})
export class DocumentTransactionModule {}
