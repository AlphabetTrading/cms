import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialRequestInput } from './dto/create-material-request.input';
import { MaterialRequestVoucher } from './model/material-request.model';
import { UpdateMaterialRequestInput } from './dto/update-material-request.input';
import { ApprovalStatus, Prisma, UserRole } from '@prisma/client';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';
import { DocumentType } from 'src/common/enums/document-type';
import * as pdf from 'html-pdf';
import { format } from 'date-fns';

@Injectable()
export class MaterialRequestService {
  constructor(private prisma: PrismaService) {}

  async createMaterialRequest(
    createMaterialRequest: CreateMaterialRequestInput,
  ): Promise<MaterialRequestVoucher> {
    const lastMaterialRequestVoucher =
      await this.prisma.materialRequestVoucher.findFirst({
        select: {
          serialNumber: true,
        },
        orderBy: {
          serialNumber: 'desc',
        },
      });
    let currentSerialNumber = 1;
    if (lastMaterialRequestVoucher) {
      currentSerialNumber =
        parseInt(lastMaterialRequestVoucher.serialNumber.split('/')[1]) + 1;
    }
    const serialNumber =
      'MRQ/' + currentSerialNumber.toString().padStart(4, '0');

    const createdMaterialRequest =
      await this.prisma.materialRequestVoucher.create({
        data: {
          ...createMaterialRequest,
          serialNumber: serialNumber,
          items: {
            create: createMaterialRequest.items.map((item) => ({
              productVariantId: item.productVariantId,
              quantity: item.quantity,
              remark: item.remark,
            })),
          },
        },
        include: {
          items: true,
          approvedBy: true,
          requestedBy: true,
          Project: true,
        },
      });
    return createdMaterialRequest;
  }

  async getMaterialRequests({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.MaterialRequestVoucherWhereInput;
    orderBy?: Prisma.MaterialRequestVoucherOrderByWithRelationInput;
  }): Promise<MaterialRequestVoucher[]> {
    const materialRequests = await this.prisma.materialRequestVoucher.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        items: {
          include: {
            productVariant: {
              include: {
                product: true,
              },
            },
            proformas: {
              include: {
                materialRequestItem: {
                  include: {
                    productVariant: true,
                  },
                },
                approvedBy: true,
                preparedBy: true,
              },
            },
          },
        },
        approvedBy: true,
        requestedBy: true,
        Project: true,
      },
    });
    return materialRequests;
  }

  async getMaterialRequestCountByStatus({
    where,
  }: {
    where?: Prisma.MaterialRequestVoucherWhereInput;
  }): Promise<any> {
    const statusCounts = await this.prisma.materialRequestVoucher.groupBy({
      by: ['status'],
      where,
      _count: {
        status: true,
      },
    });

    let counts = { COMPLETED: 0, DECLINED: 0, PENDING: 0 };

    counts = statusCounts.reduce((acc, { status, _count }) => {
      acc[status] = _count.status;
      return acc;
    }, counts);

    const documentTransaction = new DocumentTransaction();
    documentTransaction.approvedCount = counts.COMPLETED;
    documentTransaction.declinedCount = counts.DECLINED;
    documentTransaction.pendingCount = counts.PENDING;
    documentTransaction.type = DocumentType.MATERIAL_REQUEST;

    return documentTransaction;
  }

  async getMaterialRequestById(
    materialRequestId: string,
  ): Promise<MaterialRequestVoucher | null> {
    const materialRequest = await this.prisma.materialRequestVoucher.findUnique(
      {
        where: { id: materialRequestId },
        include: {
          items: {
            include: {
              productVariant: {
                include: {
                  product: true,
                },
              },
              proformas: {
                include: {
                  materialRequestItem: {
                    include: {
                      productVariant: true,
                    },
                  },
                  approvedBy: true,
                  preparedBy: true,
                },
              },
            },
          },
          approvedBy: true,
          requestedBy: true,
          Project: true,
        },
      },
    );

    return materialRequest;
  }

  async updateMaterialRequest(
    input: UpdateMaterialRequestInput,
  ): Promise<MaterialRequestVoucher> {
    const { id: materialRequestId, ...updateData } = input;

    return await this.prisma.$transaction(async (prisma) => {
      const existingMaterialRequest =
        await prisma.materialRequestVoucher.findUnique({
          where: { id: materialRequestId },
        });

      if (!existingMaterialRequest) {
        throw new NotFoundException('Material Request not found');
      }

      const itemUpdateConditions = updateData.items.map((item) => ({
        productVariantId: item.productVariantId,
      }));

      const updatedMaterialRequest = await prisma.materialRequestVoucher.update(
        {
          where: { id: materialRequestId },
          data: {
            ...updateData,
            items: {
              updateMany: {
                data: updateData.items,
                where: {
                  OR: itemUpdateConditions,
                },
              },
            },
          },
          include: {
            items: {
              include: {
                productVariant: {
                  include: {
                    product: true,
                  },
                },
                proformas: {
                  include: {
                    materialRequestItem: {
                      include: {
                        productVariant: true,
                      },
                    },
                    approvedBy: true,
                    preparedBy: true,
                  },
                },
              },
            },
            approvedBy: true,
            requestedBy: true,
            Project: true,
          },
        },
      );

      return updatedMaterialRequest;
    });
  }

  async deleteMaterialRequest(
    materialRequestId: string,
  ): Promise<MaterialRequestVoucher> {
    const existingMaterialRequest =
      await this.prisma.materialRequestVoucher.findUnique({
        where: { id: materialRequestId },
      });

    if (!existingMaterialRequest) {
      throw new NotFoundException('Material Request not found');
    }

    await this.prisma.materialRequestVoucher.delete({
      where: { id: materialRequestId },
    });

    return existingMaterialRequest;
  }

  async getMaterialRequestApprovers(projectId?: string) {
    const approvers = await this.prisma.project.findMany({
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
    return approvers;
  }

  async approveMaterialRequest(
    materialRequestId: string,
    userId: string,
    status: ApprovalStatus,
  ): Promise<MaterialRequestVoucher> {
    const materialRequest = await this.prisma.materialRequestVoucher.findUnique(
      {
        where: { id: materialRequestId },
      },
    );

    if (!materialRequest) {
      throw new NotFoundException('Material Request not found');
    }

    if (materialRequest.approvedById) {
      throw new NotFoundException('Already decided on this material request!');
    }

    const updatedMaterialRequest =
      await this.prisma.materialRequestVoucher.update({
        where: { id: materialRequestId },
        data: {
          approvedById: userId,
          status: status,
        },
      });

    return updatedMaterialRequest;
  }

  async count(
    where?: Prisma.MaterialRequestVoucherWhereInput,
  ): Promise<number> {
    return this.prisma.materialRequestVoucher.count({ where });
  }

  async generatePdf(materialRequestId: string): Promise<string> {
    const materialRequest = await this.prisma.materialRequestVoucher.findUnique(
      {
        where: { id: materialRequestId },
        include: {
          items: {
            include: {
              productVariant: {
                include: {
                  product: true,
                },
              },
              proformas: {
                include: {
                  materialRequestItem: {
                    include: {
                      productVariant: true,
                    },
                  },
                  approvedBy: true,
                  preparedBy: true,
                },
              },
            },
          },
          approvedBy: true,
          requestedBy: true,
          Project: true,
        },
      },
    );

    const htmlContent = this.getHtmlContent(materialRequest);
    return new Promise<string>((resolve, reject) => {
      pdf.create(htmlContent).toBuffer((err, buffer) => {
        if (err) {
          reject(err);
        } else {
          resolve(buffer.toString('base64'));
        }
      });
    });
  }

  private getHtmlContent(materialRequest: MaterialRequestVoucher): string {
    return `
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Material Request Voucher</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #fff;}
          .voucher { padding: 20px; margin: auto; }
          .header { text-align: center; margin-bottom: 20px; }
          .header h1 { margin: 0; font-size: 24px; text-transform: uppercase; }
          .header h2 { margin: 0; font-size: 20px; text-transform: uppercase; }
          .header-details { width: 100%; display: flex; justify-content: flex-end; margin-top: 10px; }
          .header-details div { display: flex; flex-direction: column; align-items: flex-start; }
          .header-details div label { font-weight: bold; }
          .header-details div span { margin-top: 5px; }
          .details-right { display: flex; flex-direction: column; gap: 10px; float: right; }
          .from-to { display: flex; justify-content: space-between; margin: 20px 0; }
          .from-to div { display: flex; flex-direction: column; }
          .from-to div label { font-weight: bold; }
          .from-to div span { margin-top: 5px; }
          table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
          table th, table td { border: 1px solid #000; padding: 6px; font-size: 12px; text-align: center; }
          .col-item-no { width: 6%; }
          .col-description { width: 30%; }
          .col-uom { width: 10%; }
          .col-quantity { width: 10%; }
          .col-remark { width: 12%; }
          .approval { display: flex; justify-content: space-between; margin-bottom: 20px; }
          .approval-section { display: flex; flex-direction: column; align-items: flex-start; }
          .approval-section label { font-weight: bold; }
          .approval-section span { margin-top: 5px; }
          .footer { margin-top: 20px; display: flex; flex-direction: column; }
          .footer label { font-weight: bold; }
          .footer span { margin-top: 5px; }
      </style>
    </head>
    <body>
      <div
        style="
          display: flex;
          flex-direction: row;
          justify-content: center;
          margin-top: 40px;
        "
      >
        <div
          style="
            display: flex;
            width: 85%;
            justify-content: center;
            align-items: center;
          "
        >
          <div style="width: 100%" class="voucher">
            <div class="header">
              <h1>Lucid Real Estate</h1>
              <h2>Material Request Voucher</h2>
              <div class="header-details">
                <div class="details-right">
                  <div>
                    <label>Date:</label>
                    <span id="date">${format(materialRequest.createdAt, 'MMM dd, yyyy')}</span>
                  </div>
                  <div>
                    <label>Document No:</label>
                    <span id="reference-no">${materialRequest.serialNumber}</span>
                  </div>
                </div>
              </div>
            </div>
            <table>
              <thead>
                <tr>
                  <th class="col-item-no">Item No.</th>
                  <th class="col-description">Description</th>
                  <th class="col-uom">Unit</th>
                  <th class="col-quantity">Requested Qty</th>
                  <th class="col-remark">Remark</th>
                </tr>
              </thead>
              <tbody id="items">
                  ${materialRequest.items
                    .map(
                      (item, index) => `
                <tr>
                  <td class="col-item-no">${index + 1}</td>
                  <td class="col-description">${item.productVariant.variant} ${item.productVariant.product.name}</td>
                  <td style="text-transform: lowercase;" class="col-uom">${item.productVariant.unitOfMeasure}</td>
                  <td class="col-quantity">${item.quantity}</td>
                  <td class="col-remark">${item.remark || ''}</td>
                </tr>
                `,
                    )
                    .join('')}
              </tbody>
            </table>
            <div class="approval">
              <div class="approval-section">
                <label>Prepared By:</label>
                <span id="requested-by">${materialRequest.requestedBy.fullName}</span>
              </div>
              <div class="approval-section">
                <label>Approved By:</label>
                <span id="approved-by">${materialRequest.approvedBy && materialRequest.approvedBy.fullName}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </body>
  </html>
    `;
  }
}
