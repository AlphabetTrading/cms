import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { MaterialIssueService } from 'src/material-issue/material-issue.service';
import { MaterialReceiveService } from 'src/material-receive/material-receive.service';
import { MaterialRequestService } from 'src/material-request/material-request.service';
import { MaterialReturnService } from 'src/material-return/material-return.service';
import { MaterialTransferService } from 'src/material-transfer/material-transfer.service';
import { PurchaseOrderService } from 'src/purchase-order/purchase-order.service';
import { DocumentTransaction } from './model/document-transaction-model';
import { UserRole } from '@prisma/client';

@Injectable()
export class DocumentTransactionService {
  constructor(
    private prisma: PrismaService,
    private readonly materialIssueService: MaterialIssueService,
    private readonly materialReceiveService: MaterialReceiveService,
    private readonly materialRequestService: MaterialRequestService,
    private readonly materialReturnService: MaterialReturnService,
    private readonly materialTransferService: MaterialTransferService,
    private readonly purchaseOrderService: PurchaseOrderService,
  ) {}
  async getAllDocumentsStatus(
    userId: string,
    projectId: string,
  ): Promise<DocumentTransaction[]> {
    const materialIssueReturnApprovers = await this.prisma.user.findMany({
      where: {
        role: UserRole.STORE_MANAGER,
      },
      select: {
        id: true,
      },
    });

    const materialReceiveRequestTransferPurchaseApprovers =
      await this.prisma.project.findFirst({
        where: {
          id: projectId,
        },
        select: {
          projectManagerId: true,
        },
      });

    const materialIssueReturnApproversIds = materialIssueReturnApprovers.map(
      (approver) => approver.id,
    );

    const materialIssues =
      await this.materialIssueService.getMaterialIssuesCountByStatus({
        where: {
          AND: [
            {
              projectId: projectId,
            },
            {
              OR: [
                { approvedById: { in: materialIssueReturnApproversIds } },
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
                  approvedById:
                    materialReceiveRequestTransferPurchaseApprovers?.projectManagerId,
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
                  approvedById:
                    materialReceiveRequestTransferPurchaseApprovers?.projectManagerId,
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
                  receivedById: { in: materialIssueReturnApproversIds },
                },
                {
                  returnedById: userId,
                },
              ],
            },
          ],
        },
      });

    const materialTransfers =
      await this.materialTransferService.getMaterialTransfersCountByStatus({
        where: {
          AND: [
            {
              projectId: projectId,
            },
            {
              OR: [
                {
                  approvedById:
                    materialReceiveRequestTransferPurchaseApprovers?.projectManagerId,
                },
                {
                  preparedById: userId,
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
                  approvedById:
                    materialReceiveRequestTransferPurchaseApprovers?.projectManagerId,
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
      materialTransfers,
      purchaseOrders,
    ];
  }
}
