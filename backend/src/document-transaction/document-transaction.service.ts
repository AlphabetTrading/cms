import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { MaterialIssueService } from 'src/material-issue/material-issue.service';
import { MaterialReceiveService } from 'src/material-receive/material-receive.service';
import { MaterialRequestService } from 'src/material-request/material-request.service';
import { MaterialReturnService } from 'src/material-return/material-return.service';
import { PurchaseOrderService } from 'src/purchase-order/purchase-order.service';
import { DocumentTransaction } from './model/document-transaction-model';

@Injectable()
export class DocumentTransactionService {
  constructor(
    private prisma: PrismaService,
    private readonly materialIssueService: MaterialIssueService,
    private readonly materialReceiveService: MaterialReceiveService,
    private readonly materialRequestService: MaterialRequestService,
    private readonly materialReturnService: MaterialReturnService,
    private readonly purchaseOrderService: PurchaseOrderService,
  ) {}
  async getAllDocumentsStatus(userId: string): Promise<DocumentTransaction[]> {
    const materialIssues = await this.materialIssueService.getMaterialIssuesCountByStatus({
        where: {
          OR: [
            {
              approvedById: userId,
            },
            {
              issuedToId: userId,
            },
            {
              preparedById: userId,
            },
          ],
        },
      });

    const materialReceives =
      await this.materialReceiveService.getMaterialReceiveCountByStatus({
        where: {
          OR: [
            {
              approvedById: userId,
            },
            {
              purchasedById: userId,
            },
          ],
        },
      });

    const materialRequests =
      await this.materialRequestService.getMaterialRequestCountByStatus({
        where: {
          OR: [
            {
              approvedById: userId,
            },
            {
              requestedById: userId,
            },
            {
              from: userId,
            },
            {
              to: userId,
            },
          ],
        },
      });

    const materialReturns =
      await this.materialReturnService.getMaterialReturnCountByStatus({
        where: {
          OR: [
            {
              from: userId,
            },
            {
              receivedById: userId,
            },
            {
              returnedById: userId,
            },
          ],
        },
      });

    const purchaseOrders =
      await this.purchaseOrderService.getPurchaseOrderCountByStatus({
        where: {
          OR: [
            {
              approvedById: userId,
            },
            {
              preparedById: userId,
            },
          ],
        },
      });

    return [
      materialIssues,
      materialReceives,
      materialRequests,
      materialReturns,
      purchaseOrders,
    ];
  }
}
