import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma.service';
import { Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { DailyStockBalance } from './model/daily-stock-balance.model';
import { DailyStockBalanceItem } from './model/daily-stock-balance-item.model';
import puppeteer from 'puppeteer-core';
import { format } from 'date-fns';

@Injectable()
export class DailyStockBalanceService {
  constructor(private prisma: PrismaService) {}

  @Cron('0 0 * * *')
  async recordDailyChanges(): Promise<void> {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);

    return await this.prisma.$transaction(async (prisma) => {
      const projects = await prisma.project.findMany();

      for (const project of projects) {
        const currentStocks = await prisma.warehouseProduct.findMany({
          where: { projectId: project.id },
          include: {
            productVariant: true,
            warehouse: true,
          },
        });

        const aggregatedStocks = new Map<
          string,
          {
            productVariantId: string;
            quantity: number;
            productVariant: any;
          }
        >();

        currentStocks.forEach((stockItem) => {
          const { productVariantId, quantity, productVariant } = stockItem;
          if (aggregatedStocks.has(productVariantId)) {
            aggregatedStocks.get(productVariantId)!.quantity += quantity;
          } else {
            aggregatedStocks.set(productVariantId, {
              productVariantId,
              quantity,
              productVariant,
            });
          }
        });

        const yesterdayStockBalance = await prisma.dailyStockBalance.findFirst({
          where: {
            projectId: project.id,
            createdAt: {
              lte: new Date(yesterday.setHours(23, 59, 59, 999)),
            },
          },
          orderBy: {
            createdAt: 'desc',
          },
        });

        let previousQuantities = {};
        if (yesterdayStockBalance) {
          previousQuantities = JSON.parse(
            yesterdayStockBalance.changes.toString(),
          );
        }

        const changeSummary = Array.from(aggregatedStocks.values()).reduce(
          (acc, item) => {
            const previousQuantity =
              previousQuantities[item.productVariantId]?.currentQuantity || 0;
            const currentQuantity = item.quantity;
            const change = currentQuantity - previousQuantity;

            console.log(`ProjectId: ${project.id}`);
            console.log(`ProductVariantId: ${item.productVariantId}`);
            console.log(`PreviousQuantity: ${previousQuantity}`);
            console.log(`CurrentQuantity: ${currentQuantity}`);
            console.log(`Change: ${change}`);

            // Record only the products that have changed
            if (change !== 0) {
              acc[item.productVariantId] = {
                previousQuantity,
                currentQuantity,
                change,
              };
            }
            return acc;
          },
          {},
        );

        // Only create a record if there are changes
        if (Object.keys(changeSummary).length > 0) {
          await prisma.dailyStockBalance.create({
            data: {
              projectId: project.id,
              changes: JSON.stringify(changeSummary),
            },
          });
        }
      }
    });
  }

  async getDailyStockBalances({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.DailyStockBalanceWhereInput;
    orderBy?: Prisma.MaterialIssueVoucherOrderByWithRelationInput;
  }): Promise<DailyStockBalance[]> {
    const dailyStockBalances = await this.prisma.dailyStockBalance.findMany({
      skip,
      take,
      where,
      orderBy,
    });

    return dailyStockBalances.map((dailyStockBalance) => ({
      ...dailyStockBalance,
      changes: JSON.parse(dailyStockBalance.changes as any),
    }));
  }

  async getDailyStockBalancesById(
    dailyStockBalanceId: string,
  ): Promise<DailyStockBalance> {
    const dailyStockBalance = await this.prisma.dailyStockBalance.findUnique({
      where: { id: dailyStockBalanceId },
      include: {
        Project: true,
      },
    });

    if (!dailyStockBalance) {
      return null;
    }

    return {
      ...dailyStockBalance,
      changes: JSON.parse(dailyStockBalance.changes as any),
    };
  }

  async count(where?: Prisma.DailyStockBalanceWhereInput): Promise<number> {
    return this.prisma.dailyStockBalance.count({ where });
  }

  async generatePdf(dailyStockBalanceId: string): Promise<string> {
    const dailyStockBalance = await this.prisma.dailyStockBalance.findUnique({
      where: { id: dailyStockBalanceId },
      include: {
        Project: true,
      },
    });

    const browser = await puppeteer.launch({
      executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe',
      args: ['--headless'],
    });
    const page = await browser.newPage();
    const htmlContent = await this.getHtmlContent(dailyStockBalance);
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

  async getHtmlContent(dailyStockBalance: any): Promise<string> {
    console.log(dailyStockBalance, 'STOCK');
    const jsonObject: { [key: string]: DailyStockBalanceItem } = JSON.parse(
      dailyStockBalance.changes,
    );

    const list: { key: string; value: DailyStockBalanceItem }[] =
      Object.entries(jsonObject).map(([key, value]) => ({ key, value }));

    const stockBalances = await Promise.all(
      list.map(async ({ key, value }) => {
        const variant = await this.prisma.productVariant.findUnique({
          where: {
            id: key,
          },
          include: {
            product: true,
          },
        });
        const dailyStockBalanceItem: DailyStockBalanceItem = {
          productVariantId: value.productVariantId,
          previousQuantity: value.previousQuantity || 0,
          quantityIssuedToday:
            value.currentQuantity - value.previousQuantity || 0,
          currentQuantity: value.currentQuantity || 0,
          productVariant: variant,
        };
        return { key, value: dailyStockBalanceItem };
      }),
    );

    return `
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Daily Stock Balance</title>
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
              <h2>Daily Stock Balance Report</h2>
              <div class="header-details">
                <div class="details-left">
                  <div>
                    <label>Project:</label>
                    <span id="reference-no">${dailyStockBalance.Project.name}</span>
                  </div>
                </div>
                <div class="details-right">
                  <div>
                    <label>Date:</label>
                    <span id="date">${format(dailyStockBalance.createdAt, 'MMM dd, yyyy')}</span>
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
                  <th class="col-quantity">Quantity Previous Date</th>
                  <th class="col-quantity">Quantity Today Issued</th>
                  <th class="col-quantity">Quantity Current Balance</th>
                </tr>
              </thead>
              <tbody id="items">
                  ${stockBalances
                    .map(
                      (item, index) => `
                <tr>
                  <td class="col-item-no">${index + 1}</td>
                  <td class="col-description">${item.value.productVariant.variant} ${item.value.productVariant.product.name}</td>
                  <td style="text-transform: lowercase;" class="col-uom">${item.value.productVariant.unitOfMeasure}</td>
                  <td class="col-quantity">${item.value.previousQuantity}</td>
                  <td class="col-quantity">${item.value.quantityIssuedToday}</td>
                  <td class="col-quantity">${item.value.currentQuantity}</td>
                </tr>
                `,
                    )
                    .join('')}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </body>
  </html>
    `;
  }
}
