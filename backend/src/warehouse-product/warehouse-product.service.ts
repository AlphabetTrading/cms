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
          productVariantId_warehouseId_projectId: {
            projectId: createWarehouseProduct.projectId,
            productVariantId: createWarehouseProduct.productVariantId,
            warehouseId: createWarehouseProduct.warehouseId,
          },
        },
      });

    if (existingWarehouseProduct) {
      throw new BadRequestException(
        'Product already exists in the warehouse/project!',
      );
    }

    const createdWarehouseProduct = await this.prisma.warehouseProduct.create({
      data: {
        ...createWarehouseProduct,
      },
      include: {
        productVariant: true,
        warehouse: true,
        project: true,
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
        productVariant: {
          include: {
            product: true,
          },
        },
        warehouse: true,
        project: true,
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
        project: true,
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
        project: true
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

  async getAllWarehouseProductsStock(projectId: string) {
    const allProducts = await this.prisma.productVariant.findMany({
      select: {
        id: true,
        productId: true,
        product: true,
        variant: true,
        description: true,
        unitOfMeasure: true,
      },
    });

    const warehouseProducts = await this.prisma.warehouseProduct.findMany({
      where: {
        projectId: projectId,
      },
      select: {
        productVariantId: true,
        quantity: true,
        currentPrice: true,
      },
    });

    const productMap = new Map();

    warehouseProducts.forEach((item) => {
      if (!productMap.has(item.productVariantId)) {
        productMap.set(item.productVariantId, {
          quantity: 0,
          totalValue: 0,
        });
      }
      const productData = productMap.get(item.productVariantId);
      productData.quantity += item.quantity;
      productData.totalValue += item.quantity * item.currentPrice;
    });

    const productQuantities = allProducts.map((product) => {
      const productData = productMap.get(product.id);
      if (productData) {
        return {
          productVariant: product,
          quantity: productData.quantity,
          currentPrice: productData.quantity
            ? productData.totalValue / productData.quantity
            : 0,
        };
      }
      return {
        productVariant: product,
        quantity: 0,
        currentPrice: 0,
      };
    });

    return productQuantities;
  }
}
