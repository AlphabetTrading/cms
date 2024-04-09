import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { Prisma, ProductUse } from '@prisma/client';
import { CreateProductUseInput } from './dto/create-product-use.input';
import { UpdateProductUseInput } from './dto/update-product-use.input';

@Injectable()
export class ProductUseService {
  constructor(private prisma: PrismaService) {}

  async createProductUse(
    createProductUse: CreateProductUseInput,
  ): Promise<ProductUse> {
    const createdProductUse = await this.prisma.productUse.create({
      data: {
        ...createProductUse,
      },
      include: {
        IssueVoucherItem: true,
        productVariant: true,
      },
    });

    return createdProductUse;
  }

  async getProductUses({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.ProductUseWhereInput;
    orderBy?: Prisma.ProductUseOrderByWithRelationInput;
  }): Promise<ProductUse[]> {
    const productUses = await this.prisma.productUse.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        IssueVoucherItem: true,
        productVariant: true,
      },
    });
    return productUses;
  }

  async getProductUseById(productUseId: string): Promise<ProductUse | null> {
    const productUse = await this.prisma.productUse.findUnique({
      where: { id: productUseId },
    });

    return productUse;
  }

  async updateProductUse(
    productUseId: string,
    updateData: UpdateProductUseInput,
  ): Promise<ProductUse> {
    const existingProductUse = await this.prisma.productUse.findUnique({
      where: { id: productUseId },
    });

    if (!existingProductUse) {
      throw new NotFoundException('Product use not found');
    }

    const updatedProductUse = await this.prisma.productUse.update({
      where: { id: productUseId },
      data: {
        ...updateData,
      },
      include: {
        IssueVoucherItem: true,
        productVariant: true,
      },
    });

    return updatedProductUse;
  }

  async deleteProductUse(productUseId: string): Promise<void> {
    const existingProductUse = await this.prisma.productUse.findUnique({
      where: { id: productUseId },
    });

    if (!existingProductUse) {
      throw new NotFoundException('Product use not found');
    }

    await this.prisma.productUse.delete({
      where: { id: productUseId },
    });
  }

  async count(where?: Prisma.ProductUseWhereInput): Promise<number> {
    return this.prisma.productUse.count({ where });
  }
}
