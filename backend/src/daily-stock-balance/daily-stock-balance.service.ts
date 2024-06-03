import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { Prisma } from '@prisma/client';
import { DailyStockBalance } from './model/daily-stock-balance.model';
import { Cron } from '@nestjs/schedule';

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
            changes: changeSummary,
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

  async count(where?: Prisma.DailyStockBalanceWhereInput): Promise<number> {
    return this.prisma.dailyStockBalance.count({ where });
  }
}
