import {
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { Prisma, PriceHistory } from '@prisma/client';
import { CreatePriceHistoryInput } from './dto/create-price-history.input';
import { UpdatePriceHistoryInput } from './dto/update-price-history.input';

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
        product: true,
      },
    });

    return createdPriceHistory;
  }

  async getPriceHistories({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.PriceHistoryWhereInput;
    orderBy?: Prisma.PriceHistoryOrderByWithRelationInput;
  }): Promise<PriceHistory[]> {
    const priceHistories = await this.prisma.priceHistory.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        product: true,
      },
    });
    return priceHistories;
  }

  async getPriceHistoryById(
    priceHistoryId: string,
  ): Promise<PriceHistory | null> {
    const priceHistory = await this.prisma.priceHistory.findUnique({
      where: { id: priceHistoryId },
      include: {
        product: true,
      },
    });

    return priceHistory;
  }

  async updatePriceHistory(
    priceHistoryId: string,
    updateData: UpdatePriceHistoryInput,
  ): Promise<PriceHistory> {
    const existingPriceHistory =
      await this.prisma.priceHistory.findUnique({
        where: { id: priceHistoryId },
      });

    if (!existingPriceHistory) {
      throw new NotFoundException('Product not found in warehouse');
    }

    const updatedPriceHistory = await this.prisma.priceHistory.update({
      where: { id: priceHistoryId },
      data: {
        ...updateData,
      },
      include: {
        product: true,
      },
    });

    return updatedPriceHistory;
  }

  async deletePriceHistory(priceHistoryId: string): Promise<void> {
    const existingPriceHistory =
      await this.prisma.priceHistory.findUnique({
        where: { id: priceHistoryId },
      });

    if (!existingPriceHistory) {
      throw new NotFoundException('Product not found in warehouse');
    }

    await this.prisma.priceHistory.delete({
      where: { id: priceHistoryId },
    });
  }

  async count(where?: Prisma.PriceHistoryWhereInput): Promise<number> {
    return this.prisma.priceHistory.count({ where });
  }
}
