import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { Prisma, PriceHistory } from '@prisma/client';
import { CreatePriceHistoryInput } from './dto/create-price-history.input';

@Injectable()
export class PriceHistoryService {
  constructor(private prisma: PrismaService) {}

  async createPriceHistory(
    createPriceHistory: CreatePriceHistoryInput,
  ): Promise<PriceHistory> {
    const createdPriceHistory = await this.prisma.priceHistory.create({
      data: {
        ...createPriceHistory,
      },
      include: {
        productVariant: {
          include: {
            product: true,
          },
        },
        company: true,
      },
    });

    return createdPriceHistory;
  }

  async getPriceHistories({
    where,
  }: {
    where?: Prisma.PriceHistoryWhereInput;
  }): Promise<PriceHistory[]> {
    const priceHistories = await this.prisma.priceHistory.findMany({
      where,
      include: {
        productVariant: {
          include: {
            product: true,
          },
        },
        company: true,
      },
    });
    return priceHistories;
  }

  async count(where?: Prisma.PriceHistoryWhereInput): Promise<number> {
    return this.prisma.priceHistory.count({ where });
  }
}
