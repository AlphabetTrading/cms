import { Prisma } from '@prisma/client';
import { PrismaService } from 'src/prisma.service';
import { Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { DailyStockBalance } from './model/daily-stock-balance.model';
import { DailyStockBalanceItem } from './model/daily-stock-balance-item.model';

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
        const changes = await prisma.warehouseProduct.findMany({
          where: {
            updatedAt: {
              gte: new Date(yesterday.setHours(0, 0, 0, 0)),
              lt: new Date(yesterday.setHours(23, 59, 59, 999)),
            },
            projectId: project.id,
          },
        });

        const changeSummary = changes.reduce((acc, item) => {
          acc[item.productVariantId] =
            (acc[item.productVariantId] || 0) + item.quantity;
          return acc;
        }, {});

        await prisma.dailyStockBalance.create({
          data: {
            projectId: project.id,
            changes: JSON.stringify(changeSummary),
          },
        });
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
  ): Promise<DailyStockBalanceItem[]> {
    const dailyStockBalance = await this.prisma.dailyStockBalance.findUnique({
      where: { id: dailyStockBalanceId },
      include: {
        Project: true,
      },
    });

    const changes = JSON.parse(dailyStockBalance.changes.toString());

    const currentStocks = await this.prisma.warehouseProduct.findMany({
      where: {
        projectId: dailyStockBalance.projectId,
      },
      include: {
        productVariant: {
          include: {
            product: true,
          },
        },
        warehouse: true,
      },
    });

    const stockBalances = currentStocks.map((stockItem) => {
      const dailyStockBalanceItem: DailyStockBalanceItem = {
        productVariantId: stockItem.productVariantId,
        previousQuantity: changes[stockItem.productVariantId] || 0,
        quantityIssuedToday:
          stockItem.quantity - changes[stockItem.productVariantId] || 0,
        currentQuantity: stockItem.quantity,
        productVariant: stockItem.productVariant,
      };
      return dailyStockBalanceItem;
    });

    return stockBalances;
  }

  async count(where?: Prisma.DailyStockBalanceWhereInput): Promise<number> {
    return this.prisma.dailyStockBalance.count({ where });
  }
}
