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
import { DailySiteDataService } from 'src/daily-site-data/daily-site-data.service';
import { ProformaService } from 'src/proforma/proforma.service';

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
    private readonly proformaService: ProformaService,
    private readonly dailySiteDataService: DailySiteDataService,
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
          ProjectUsers: {
            where: {
              user: {
                role: UserRole.PROJECT_MANAGER,
              },
            },
            select: {
              userId: true,
            },
          },
        },
      });

    const materialIssueReturnApproversIds = materialIssueReturnApprovers.map(
      (approver) => approver.id,
    );

    const materialReceiveRequestTransferPurchaseApproversIds =
      materialReceiveRequestTransferPurchaseApprovers.ProjectUsers.map(
        (approver) => approver.userId,
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
                { approvedById: userId },
                {
                  preparedById: userId,
                },
                ...(materialIssueReturnApproversIds.includes(userId)
                  ? [
                      {
                        projectId: projectId,
                      },
                    ]
                  : []),
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
                ...(materialReceiveRequestTransferPurchaseApproversIds.includes(
                  userId,
                )
                  ? [
                      {
                        projectId: projectId,
                      },
                    ]
                  : []),
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
                ...(materialReceiveRequestTransferPurchaseApproversIds.includes(
                  userId,
                )
                  ? [
                      {
                        projectId: projectId,
                      },
                    ]
                  : []),
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
                ...(materialIssueReturnApproversIds.includes(userId)
                  ? [
                      {
                        projectId: projectId,
                      },
                    ]
                  : []),

                ...(materialReceiveRequestTransferPurchaseApproversIds.includes(
                  userId,
                )
                  ? [
                      {
                        projectId: projectId,
                      },
                    ]
                  : []),
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
                  approvedById: userId,
                },
                {
                  preparedById: userId,
                },
                ...(materialReceiveRequestTransferPurchaseApproversIds.includes(
                  userId,
                )
                  ? [
                      {
                        projectId: projectId,
                      },
                    ]
                  : []),
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
                ...(materialReceiveRequestTransferPurchaseApproversIds.includes(
                  userId,
                )
                  ? [
                      {
                        projectId: projectId,
                      },
                    ]
                  : []),
              ],
            },
          ],
        },
      });

    const dailySiteDatas =
      await this.dailySiteDataService.getDailySiteDataCountByStatus({
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
                ...(materialReceiveRequestTransferPurchaseApproversIds.includes(
                  userId,
                )
                  ? [
                      {
                        projectId: projectId,
                      },
                    ]
                  : []),
              ],
            },
          ],
        },
      });

    const proformas = await this.proformaService.getProformaCountByStatus({
      where: {
        AND: [
          {
            projectId: projectId,
          },
          {
            OR: [
              {
                approvedById: {
                  in: materialReceiveRequestTransferPurchaseApproversIds,
                },
              },
              {
                preparedById: userId,
              },
              ...(materialReceiveRequestTransferPurchaseApproversIds.includes(
                userId,
              )
                ? [
                    {
                      projectId: projectId,
                    },
                  ]
                : []),
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
      proformas,
      dailySiteDatas,
    ];
  }
}
