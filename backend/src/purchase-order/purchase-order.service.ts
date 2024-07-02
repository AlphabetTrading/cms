import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreatePurchaseOrderInput } from './dto/create-purchase-order.input';
import { PurchaseOrderVoucher } from './model/purchase-order.model';
import { UpdatePurchaseOrderInput } from './dto/update-purchase-order.input';
import { ApprovalStatus, Prisma, UserRole } from '@prisma/client';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';
import { DocumentType } from 'src/common/enums/document-type';
import puppeteer from 'puppeteer-core';
import { format } from 'date-fns';

@Injectable()
export class PurchaseOrderService {
  constructor(private prisma: PrismaService) {}

  async createPurchaseOrder(
    createPurchaseOrder: CreatePurchaseOrderInput,
  ): Promise<PurchaseOrderVoucher> {
    const lastPurchaseOrderVoucher = await this.prisma.purchaseOrder.findFirst({
      select: {
        serialNumber: true,
      },
      orderBy: {
        serialNumber: 'desc',
      },
    });
    let currentSerialNumber = 1;
    if (lastPurchaseOrderVoucher) {
      currentSerialNumber =
        parseInt(lastPurchaseOrderVoucher.serialNumber.split('/')[1]) + 1;
    }
    const serialNumber =
      'PO/' + currentSerialNumber.toString().padStart(4, '0');

    const createdPurchaseOrder = await this.prisma.purchaseOrder.create({
      data: {
        ...createPurchaseOrder,
        serialNumber: serialNumber,
        items: {
          create: createPurchaseOrder.items.map((item) => ({
            productVariantId: item.productVariantId,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            totalPrice: item.totalPrice,
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
        approvedBy: true,
        MaterialReceiveVouchers: true,
        materialRequest: true,
        preparedBy: true,
        Project: true,
      },
    });
    return createdPurchaseOrder;
  }

  async getPurchaseOrders({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.PurchaseOrderWhereInput;
    orderBy?: Prisma.PurchaseOrderOrderByWithRelationInput;
  }): Promise<PurchaseOrderVoucher[]> {
    const purchaseOrders = await this.prisma.purchaseOrder.findMany({
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
        approvedBy: true,
        MaterialReceiveVouchers: true,
        materialRequest: true,
        preparedBy: true,
        Project: true,
      },
    });
    return purchaseOrders;
  }

  async getPurchaseOrderCountByStatus({
    where,
  }: {
    where?: Prisma.PurchaseOrderWhereInput;
  }): Promise<any> {
    const statusCounts = await this.prisma.purchaseOrder.groupBy({
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
    documentTransaction.type = DocumentType.PURCHASE_ORDER;

    return documentTransaction;
  }

  async getPurchaseOrderById(
    purchaseOrderId: string,
  ): Promise<PurchaseOrderVoucher | null> {
    const purchaseOrder = await this.prisma.purchaseOrder.findUnique({
      where: { id: purchaseOrderId },
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
        approvedBy: true,
        MaterialReceiveVouchers: true,
        materialRequest: true,
        preparedBy: true,
        Project: true,
      },
    });

    return purchaseOrder;
  }

  async updatePurchaseOrder(
    input: UpdatePurchaseOrderInput,
  ): Promise<PurchaseOrderVoucher> {
    const { id: purchaseOrderId, ...updateData } = input;

    return await this.prisma.$transaction(async (prisma) => {
      const existingPurchaseOrder = await prisma.purchaseOrder.findUnique({
        where: { id: purchaseOrderId },
      });

      if (!existingPurchaseOrder) {
        throw new NotFoundException('Purchase Order not found');
      }

      const itemUpdateConditions = updateData.items.map((item) => ({
        productVariantId: item.productVariantId,
      }));

      const updatedPurchaseOrder = await prisma.purchaseOrder.update({
        where: { id: purchaseOrderId },
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
          approvedBy: true,
          MaterialReceiveVouchers: true,
          materialRequest: true,
          preparedBy: true,
          Project: true,
        },
      });

      return updatedPurchaseOrder;
    });
  }

  async deletePurchaseOrder(
    purchaseOrderId: string,
  ): Promise<PurchaseOrderVoucher> {
    const existingPurchaseOrder = await this.prisma.purchaseOrder.findUnique({
      where: { id: purchaseOrderId },
    });

    if (!existingPurchaseOrder) {
      throw new NotFoundException('Purchase Order not found');
    }

    await this.prisma.purchaseOrder.delete({
      where: { id: purchaseOrderId },
    });

    return existingPurchaseOrder;
  }

  async getPurchaseOrderApprovers(projectId?: string) {
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

  async approvePurchaseOrder(
    purchaseOrderId: string,
    userId: string,
    status: ApprovalStatus,
  ) {
    const purchaseOrder = await this.prisma.purchaseOrder.findUnique({
      where: { id: purchaseOrderId },
    });

    if (!purchaseOrder) {
      throw new NotFoundException('Purchase Order not found');
    }

    if (purchaseOrder.approvedById) {
      throw new NotFoundException('Already decided on this purchase order!');
    }

    const updatedPurchaseOrder = await this.prisma.purchaseOrder.update({
      where: { id: purchaseOrderId },
      data: {
        approvedById: userId,
        status: status,
      },
    });

    return updatedPurchaseOrder;
  }

  async count(where?: Prisma.PurchaseOrderWhereInput): Promise<number> {
    return this.prisma.purchaseOrder.count({ where });
  }

  async generatePdf(purchaseOrderId: string): Promise<string> {
    const purchaseOrder = await this.prisma.purchaseOrder.findUnique({
      where: { id: purchaseOrderId },
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
        approvedBy: true,
        MaterialReceiveVouchers: true,
        materialRequest: true,
        preparedBy: true,
        Project: true,
      },
    });

    const browser = await puppeteer.launch({
      executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe',
      args: ['--headless'],
    });
    const page = await browser.newPage();
    const htmlContent = this.getHtmlContent(purchaseOrder);
    await page.setContent(htmlContent);
    const pdfBuffer = await page.pdf({
      path: 'hello.pdf',
      format: 'A4',
      printBackground: true,
      margin: {
        left: '0px',
        top: '0px',
        right: '0px',
        bottom: '0px',
      },
    });
    await browser.close();
    return pdfBuffer.toString('base64');
  }

  private getHtmlContent(purchaseOrder: PurchaseOrderVoucher): string {
    return `
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Purchase Order Voucher</title>
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
              <h2>Purchase Order Voucher</h2>
              <div class="header-details">
                <div class="details-left">
                  <div>
                    <label>Date:</label>
                    <span id="date">${format(purchaseOrder.createdAt, 'MMM dd, yyyy')}</span>
                  </div>
                  <div>
                    <label>Project:</label>
                    <span>${purchaseOrder.Project.name}</span>
                  </div>
                  <div>
                    <label>Supplier Name:</label>
                    <span>${purchaseOrder.supplierName || ''}</span>
                  </div>
                </div>
                <div class="details-right">
                  <div>
                    <label>Document No:</label>
                    <span id="reference-no">${purchaseOrder.serialNumber}</span>
                  </div>
                  <div>
                    <label>Material Req. No:</label>
                    <span id="reference-no">${purchaseOrder.materialRequest.serialNumber || ''}</span>
                  </div>

                  <div>
                    <label>Date Material Requested:</label>
                    <span id="store-name">${format(purchaseOrder.materialRequest.createdAt, 'MMM dd, yyyy')}</span>
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
                  ${purchaseOrder.items
                    .map(
                      (item, index) => `
                <tr>
                  <td class="col-item-no">${index + 1}</td>
                  <td class="col-description">${item.productVariant.variant} ${item.productVariant.product.name}</td>
                  <td style="text-transform: lowercase;" class="col-uom">${item.productVariant.unitOfMeasure}</td>
                  <td class="col-quantity">${item.quantity}</td>
                  <td class="col-cost-money">${item.unitPrice.toLocaleString().split('.')[0]}</td>
                  <td class="col-cost-cent">${(item.unitPrice.toString().split('.')[1] || '00').padEnd(2, '0')}</td>
                  <td class="col-cost-money">${item.totalPrice.toLocaleString().split('.')[0]}</td>
                  <td class="col-cost-cent">${(item.totalPrice.toString().split('.')[1] || '00').padEnd(2, '0')}</td>
                  <td class="col-remark">${item.remark || ''}</td>
                </tr>
                `,
                    )
                    .join('')}
              </tbody>
              <tfoot>
                <tr>
                  <td colspan="6" class="col-cost" style="text-align: right; border: none; ">Sub Total</td>
                  <td class="col-cost-money">${purchaseOrder.subTotal.toLocaleString().split('.')[0]}</td>
                  <td class="col-cost-cent">${(purchaseOrder.subTotal.toString().split('.')[1] || '00').padEnd(2, '0')}</td>
                  <td></td>
                </tr>
                <tr>
                  <td colspan="6" class="col-cost" style="text-align: right; border: none;">15% VAT</td>
                  <td class="col-cost-money">${purchaseOrder.vat.toLocaleString().split('.')[0]}</td>
                  <td class="col-cost-cent">${(purchaseOrder.vat.toString().split('.')[1] || '00').padEnd(2, '0')}</td>
                  <td></td>
                </tr>
                <tr>
                  <td colspan="6" class="col-cost" style="text-align: right; border: none;">Grand Total</td>
                  <td class="col-cost-money">${purchaseOrder.grandTotal.toLocaleString().split('.')[0]}</td>
                  <td class="col-cost-cent">${(purchaseOrder.grandTotal.toString().split('.')[1] || '00').padEnd(2, '0')}</td>
                  <td></td>
                </tr>
              </tfoot>
            </table>
            <div class="approval">
              <div class="approval-section">
                <label>Prepared By:</label>
                <span id="requested-by">${purchaseOrder.preparedBy.fullName}</span>
              </div>
              <div class="approval-section">
                <label>Approved By:</label>
                <span id="approved-by">${purchaseOrder.approvedBy && purchaseOrder.approvedBy.fullName}</span>
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
