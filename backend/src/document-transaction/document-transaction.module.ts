import { Module } from '@nestjs/common';
import { DocumentTransactionService } from './document-transaction.service';
import { DocumentTransactionResolver } from './document-transaction.resolver';
import { MaterialReceiveModule } from 'src/material-receive/material-receive.module';
import { MaterialIssueModule } from 'src/material-issue/material-issue.module';
import { MaterialRequestModule } from 'src/material-request/material-request.module';
import { MaterialReturnModule } from 'src/material-return/material-return.module';
import { PurchaseOrderModule } from 'src/purchase-order/purchase-order.module';
import { MaterialTransferModule } from 'src/material-transfer/material-transfer.module';
import { ProformaModule } from 'src/proforma/proforma.module';
import { DailySiteDataModule } from 'src/daily-site-data/daily-site-data.module';
import { DailyStockBalanceModule } from 'src/daily-stock-balance/daily-stock-balance.module';

@Module({
  imports: [
    MaterialReceiveModule,
    MaterialIssueModule,
    MaterialReturnModule,
    MaterialRequestModule,
    MaterialTransferModule,
    PurchaseOrderModule,
    ProformaModule,
    DailySiteDataModule,
    DailyStockBalanceModule
  ],
  providers: [DocumentTransactionResolver, DocumentTransactionService],
  exports: [DocumentTransactionService],
})
export class DocumentTransactionModule {}
