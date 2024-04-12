import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { Prisma, WarehouseProduct } from '@prisma/client';
import { CreateWarehouseProductInput } from './dto/create-warehouse-product.input';
import { UpdateWarehouseProductInput } from './dto/update-warehouse-product.input';

@Injectable()
export class WarehouseProductService {
  constructor(private prisma: PrismaService) {}

  async createWarehouseProduct(
    createWarehouseProduct: CreateWarehouseProductInput,
  ): Promise<WarehouseProduct> {
    const existingWarehouseProduct =
      await this.prisma.warehouseProduct.findUnique({
        where: {
          productId_warehouseId: {
            productId: createWarehouseProduct.productId,
            warehouseId: createWarehouseProduct.warehouseId,
          },
        },
      });

    if (existingWarehouseProduct) {
      throw new BadRequestException('Product already exists in the warehouse!');
    }

    const createdWarehouseProduct = await this.prisma.warehouseProduct.create({
      data: {
        ...createWarehouseProduct,
      },
      include: {
        productVariant: true,
        warehouse: true,
      },
    });

    return createdWarehouseProduct;
  }

  async getWarehouseProducts({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.WarehouseProductWhereInput;
    orderBy?: Prisma.WarehouseProductOrderByWithRelationInput;
  }): Promise<WarehouseProduct[]> {
    const warehouseProducts = await this.prisma.warehouseProduct.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        productVariant: true,
        warehouse: true,
      },
    });
    return warehouseProducts;
  }

  async getWarehouseProductById(
    warehouseProductId: string,
  ): Promise<WarehouseProduct | null> {
    const warehouseProduct = await this.prisma.warehouseProduct.findUnique({
      where: { id: warehouseProductId },
      include: {
        productVariant: true,
        warehouse: true,
      },
    });

    return warehouseProduct;
  }

  async updateWarehouseProduct(
    warehouseProductId: string,
    updateData: UpdateWarehouseProductInput,
  ): Promise<WarehouseProduct> {
    const existingWarehouseProduct =
      await this.prisma.warehouseProduct.findUnique({
        where: { id: warehouseProductId },
      });

    if (!existingWarehouseProduct) {
      throw new NotFoundException('Product not found in warehouse');
    }

    const updatedWarehouseProduct = await this.prisma.warehouseProduct.update({
      where: { id: warehouseProductId },
      data: {
        ...updateData,
      },
      include: {
        productVariant: true,
        warehouse: true,
      },
    });

    return updatedWarehouseProduct;
  }

  async deleteWarehouseProduct(warehouseProductId: string): Promise<void> {
    const existingWarehouseProduct =
      await this.prisma.warehouseProduct.findUnique({
        where: { id: warehouseProductId },
      });

    if (!existingWarehouseProduct) {
      throw new NotFoundException('Product not found in warehouse');
    }

    await this.prisma.warehouseProduct.delete({
      where: { id: warehouseProductId },
    });
  }

  async count(where?: Prisma.WarehouseProductWhereInput): Promise<number> {
    return this.prisma.warehouseProduct.count({ where });
  }

  async getAllWarehouseProductsStock() {
    const allProducts = await this.prisma.productVariant.findMany({
      select: {
        id: true,
        product: true,
        variant: true
      },
    });

    const warehouseQuantities = await this.prisma.warehouseProduct.groupBy({
      by: ['productId'],
      _sum: {
        quantity: true,
      },
    });

    const quantityMap = new Map(
      warehouseQuantities.map((item) => [item.productId, item._sum.quantity]),
    );

    const productQuantities = allProducts.map((product) => {
      return {
        productId: product.id,
        product: product,
        quantity: quantityMap.get(product.id) || 0,
      };
    });

    return productQuantities;
  }
}
