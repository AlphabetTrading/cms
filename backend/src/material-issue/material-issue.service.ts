import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMaterialIssueInput } from './dto/create-material-issue.input';
import { UpdateMaterialIssueInput } from './dto/update-material-issue.input';
import { MaterialIssueVoucher } from './model/material-issue.model';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DocumentType } from 'src/common/enums/document-type';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';
import * as pdf from 'html-pdf';
import { format } from 'date-fns';

@Injectable()
export class MaterialIssueService {
  constructor(private prisma: PrismaService) {}

  async createMaterialIssue(
    createMaterialIssueInput: CreateMaterialIssueInput,
  ): Promise<MaterialIssueVoucher> {
    const lastMaterialIssueVoucher =
      await this.prisma.materialIssueVoucher.findFirst({
        select: {
          serialNumber: true,
        },
        orderBy: {
          serialNumber: 'desc',
        },
      });
    let currentSerialNumber = 1;
    if (lastMaterialIssueVoucher) {
      currentSerialNumber =
        parseInt(lastMaterialIssueVoucher.serialNumber.split('/')[1]) + 1;
    }
    const serialNumber =
      'ISS/' + currentSerialNumber.toString().padStart(4, '0');

    const createdMaterialIssue = await this.prisma.materialIssueVoucher.create({
      data: {
        ...createMaterialIssueInput,
        serialNumber: serialNumber,
        items: {
          create: createMaterialIssueInput.items.map((item) => ({
            productVariantId: item.productVariantId,
            useType: item.useType,
            subStructureDescription: item.subStructureDescription,
            superStructureDescription: item.superStructureDescription,
            quantity: item.quantity,
            unitCost: item.unitCost,
            totalCost: item.totalCost,
            remark: item.remark,
          })),
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
          },
        },
        Project: true,
        warehouseStore: true,
        approvedBy: true,
        preparedBy: true,
      },
    });
    return createdMaterialIssue;
  }

  async getMaterialIssues({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.MaterialIssueVoucherWhereInput;
    orderBy?: Prisma.MaterialIssueVoucherOrderByWithRelationInput;
  }): Promise<MaterialIssueVoucher[]> {
    const materialIssues = await this.prisma.materialIssueVoucher.findMany({
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
          },
        },
        Project: true,
        warehouseStore: true,
        approvedBy: true,
        preparedBy: true,
      },
    });
    return materialIssues;
  }

  async getMaterialIssuesCountByStatus({
    where,
  }: {
    where?: Prisma.MaterialIssueVoucherWhereInput;
  }): Promise<any> {
    const statusCounts = await this.prisma.materialIssueVoucher.groupBy({
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
    documentTransaction.type = DocumentType.MATERIAL_ISSUE;

    return documentTransaction;
  }
  async getMaterialIssueById(
    materialIssueId: string,
  ): Promise<MaterialIssueVoucher | null> {
    const materialIssue = await this.prisma.materialIssueVoucher.findUnique({
      where: { id: materialIssueId },
      include: {
        items: {
          include: {
            productVariant: {
              include: {
                product: true,
              },
            },
          },
        },
        Project: true,
        warehouseStore: true,
        approvedBy: true,
        preparedBy: true,
      },
    });

    return materialIssue;
  }

  async updateMaterialIssue(
    input: UpdateMaterialIssueInput,
  ): Promise<MaterialIssueVoucher> {
    const { id: materialIssueId, ...updateData } = input;

    return await this.prisma.$transaction(async (prisma) => {
      const existingMaterialIssue =
        await prisma.materialIssueVoucher.findUnique({
          where: { id: materialIssueId },
        });

      if (!existingMaterialIssue) {
        throw new NotFoundException('Material Issue not found');
      }

      const itemUpdateConditions = updateData.items.map((item) => ({
        productVariantId: item.productVariantId,
      }));

      const updatedMaterialIssue = await prisma.materialIssueVoucher.update({
        where: { id: materialIssueId },
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
            },
          },
          Project: true,
          warehouseStore: true,
          approvedBy: true,
          preparedBy: true,
        },
      });

      return updatedMaterialIssue;
    });
  }

  async deleteMaterialIssue(
    materialIssueId: string,
  ): Promise<MaterialIssueVoucher> {
    const existingMaterialIssue =
      await this.prisma.materialIssueVoucher.findUnique({
        where: { id: materialIssueId },
      });

    if (!existingMaterialIssue) {
      throw new NotFoundException('Material Issue not found');
    }

    await this.prisma.materialIssueVoucher.delete({
      where: { id: materialIssueId },
    });

    return existingMaterialIssue;
  }

  async getMaterialIssueApprovers(projectId: string) {
    const approvers = await this.prisma.project.findUnique({
      where: {
        id: projectId,
      },
      include: {
        company: {
          include: {
            warehouseStores: {
              include: {
                warehouseStoreManagers: true,
              },
            },
          },
        },
      },
    });

    return approvers.company.warehouseStores.flatMap(
      (warehouseStore) => warehouseStore.warehouseStoreManagers,
    );
  }

  async approveMaterialIssue(
    materialIssueId: string,
    userId: string,
    status: ApprovalStatus,
  ): Promise<MaterialIssueVoucher> {
    const materialIssue = await this.prisma.materialIssueVoucher.findUnique({
      where: { id: materialIssueId },
      include: {
        items: {
          include: {
            productVariant: true,
          },
        },
      },
    });

    if (!materialIssue) {
      throw new NotFoundException('Material Issue not found');
    }

    if (materialIssue.approvedById) {
      throw new NotFoundException('Already decided on this material issue!');
    }

    if (status === ApprovalStatus.COMPLETED) {
      return await this.prisma.$transaction(async (prisma) => {
        for (const item of materialIssue.items) {
          const stock = await prisma.warehouseProduct.findUnique({
            where: {
              productVariantId_warehouseId_projectId: {
                productVariantId: item.productVariantId,
                warehouseId: materialIssue.warehouseStoreId,
                projectId: materialIssue.projectId,
              },
            },
          });

          if (!stock || stock.quantity < item.quantity) {
            throw new ConflictException(
              `Not enough stock available for ${item.productVariant.variant}`,
            );
          }

          await prisma.warehouseProduct.update({
            where: {
              id: stock.id,
              version: stock.version,
            },
            data: {
              quantity: stock.quantity - item.quantity,
              version: stock.version + 1,
            },
          });
        }
        const updatedMaterialIssue = await prisma.materialIssueVoucher.update({
          where: { id: materialIssueId },
          data: { status: status, approvedById: userId },
        });

        return updatedMaterialIssue;
      });
    } else {
      const updatedMaterialIssue =
        await this.prisma.materialIssueVoucher.update({
          where: { id: materialIssueId },
          data: {
            approvedById: userId,
            status: status,
          },
        });
      return updatedMaterialIssue;
    }
  }

  async count(where?: Prisma.MaterialIssueVoucherWhereInput): Promise<number> {
    return this.prisma.materialIssueVoucher.count({ where });
  }

  async generatePdf(materialIssueId: string): Promise<string> {
    const materialIssue = await this.prisma.materialIssueVoucher.findUnique({
      where: { id: materialIssueId },
      include: {
        items: {
          include: {
            productVariant: {
              include: {
                product: true,
              },
            },
          },
        },
        Project: true,
        warehouseStore: true,
        approvedBy: true,
        preparedBy: true,
      },
    });

    const htmlContent = this.getHtmlContent(materialIssue);

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

  private getHtmlContent(materialIssue: MaterialIssueVoucher): string {
    return `
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Material Issue Voucher</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #fff;}
          .voucher { padding: 20px; margin: auto; }
          .header { text-align: center; margin-bottom: 20px; }
          .header h1 { margin: 0; font-size: 24px; text-transform: uppercase; }
          .header h2 { margin: 0; font-size: 20px; text-transform: uppercase; }
          .header-details { display: flex; justify-content: space-between; margin-top: 10px; }
          .header-details div { display: flex; flex-direction: column; align-items: flex-start; }
          .header-details div label { font-weight: bold; }
          .header-details div span { margin-top: 5px; }
          .details-left { display: flex; flex-direction: column; gap: 10px; }
          .details-right { display: flex; flex-direction: column; gap: 10px; }
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
          .col-cost { width: 15%; }
          .col-cost-money{ width: 10%; }
          .col-cost-cent{ width: 5%; }
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
              <h2>Material Issue Voucher</h2>
              <div class="header-details">
                <div class="details-left">
                  <div>
                    <label>Date:</label>
                    <span id="date">${format(materialIssue.createdAt, 'MMM dd, yyyy')}</span>
                  </div>
                  <div>
                    <label>Document No:</label>
                    <span id="reference-no">${materialIssue.serialNumber}</span>
                  </div>
                </div>
                <div class="details-right">
                  <div>
                    <label>Store Name:</label>
                    <span id="store-name">${materialIssue.warehouseStore.name}</span>
                  </div>
                  <div>
                    <label>Store Location:</label>
                    <span id="store-location">${materialIssue.warehouseStore.location}</span>
                  </div>
                </div>
              </div>
            </div>
            <table>
              <thead>
                <tr>
                  <th class="col-item-no">Item No.</th>
                  <th class="col-description">Description</th>
                  <th class="col-uom">Unit of Measure</th>
                  <th class="col-quantity">Quantity</th>
                  <th colspan="2" class="col-cost">Unit Cost</th>
                  <th colspan="2" class="col-cost">Total Cost</th>
                  <th class="col-remark">Remark</th>
                </tr>
              </thead>
              <tbody id="items">
                  ${materialIssue.items
                    .map(
                      (item, index) => `
                <tr>
                  <td class="col-item-no">${index + 1}</td>
                  <td class="col-description">${item.productVariant.variant} ${item.productVariant.product.name}</td>
                  <td style="text-transform: lowercase;" class="col-uom">${item.productVariant.unitOfMeasure}</td>
                  <td class="col-quantity">${item.quantity}</td>
                 <td class="col-cost-money">${item.unitCost.toLocaleString().split('.')[0]}</td>
                  <td class="col-cost-cent">${(item.unitCost.toString().split('.')[1] || '00').padEnd(2, '0')}</td>
                  <td class="col-cost-money">${item.totalCost.toLocaleString().split('.')[0]}</td>
                  <td class="col-cost-cent">${(item.totalCost.toString().split('.')[1] || '00').padEnd(2, '0')}</td>
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
                <span id="requested-by">${materialIssue.preparedBy.fullName}</span>
              </div>
              <div class="approval-section">
                <label>Approved By:</label>
                <span id="approved-by">${materialIssue.approvedBy && materialIssue.approvedBy.fullName}</span>
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
