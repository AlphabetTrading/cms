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
  async getAllDocumentsStatus(
    userId: string,
    projectId: string,
  ): Promise<DocumentTransaction[]> {
    const materialIssues =
      await this.materialIssueService.getMaterialIssuesCountByStatus({
        where: {
          AND: [
            {
              projectId: projectId,
            },
            {
              OR: [
                {
                  approvedById: userId,
                },
                {
                  preparedById: userId,
                },
              ],
            },
          ],
        },
      });

    const materialReceives =
      await this.materialReceiveService.getMaterialReceiveCountByStatus({
        where: {
          AND: [
            {
              projectId: projectId,
            },
            {
              OR: [
                {
                  approvedById: userId,
                },
                {
                  purchasedById: userId,
                },
              ],
            },
          ],
        },
      });

    const materialRequests =
      await this.materialRequestService.getMaterialRequestCountByStatus({
        where: {
          AND: [
            {
              projectId: projectId,
            },
            {
              OR: [
                {
                  approvedById: userId,
                },
                {
                  requestedById: userId,
                },
              ],
            },
          ],
        },
      });

    const materialReturns =
      await this.materialReturnService.getMaterialReturnCountByStatus({
        where: {
          AND: [
            {
              projectId: projectId,
            },
            {
              OR: [
                {
                  receivedById: userId,
                },
                {
                  returnedById: userId,
                },
              ],
            },
          ],
        },
      });

    const purchaseOrders =
      await this.purchaseOrderService.getPurchaseOrderCountByStatus({
        where: {
          AND: [
            {
              projectId: projectId,
            },
            {
              OR: [
                {
                  approvedById: userId,
                },
                {
                  preparedById: userId,
                },
              ],
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
