import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { Prisma, ProductVariant } from '@prisma/client';
import { CreateProductVariantInput } from './dto/create-product-variant.input';
import { UpdateProductVariantInput } from './dto/update-product-variant.input';

@Injectable()
export class ProductVariantService {
  constructor(private prisma: PrismaService) {}

  async createProductVariant(
    createProductVariant: CreateProductVariantInput,
  ): Promise<ProductVariant> {
    const existingProductVariant = await this.prisma.productVariant.findUnique({
      where: {
        productId_variant: {
          productId: createProductVariant.productId,
          variant: createProductVariant.variant,
        },
      },
    });

    if (existingProductVariant) {
      throw new BadRequestException('Product variant already exists!');
    }

    const createdProductVariant = await this.prisma.productVariant.create({
      data: {
        ...createProductVariant,
      },
      include: {
        product: true,
        WarehouseProduct: true,
        ProductUse: true,
        PriceHistory: true,
        MaterialReceiveItem: true,
        MaterialRequestItem: true,
        PurchaseOrderItem: true,
        ReturnVoucherItem: true,
      },
    });

    return createdProductVariant;
  }

  async getProductVariants({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.ProductVariantWhereInput;
    orderBy?: Prisma.ProductVariantOrderByWithRelationInput;
  }): Promise<ProductVariant[]> {
    const productVariants = await this.prisma.productVariant.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        product: true,
        WarehouseProduct: true,
        ProductUse: true,
        PriceHistory: true,
        MaterialReceiveItem: true,
        MaterialRequestItem: true,
        PurchaseOrderItem: true,
        ReturnVoucherItem: true,
      },
    });
    return productVariants;
  }

  async getProductVariantById(
    productVariantId: string,
  ): Promise<ProductVariant | null> {
    const productVariant = await this.prisma.productVariant.findUnique({
      where: { id: productVariantId },
      include: {
        product: true,
        WarehouseProduct: true,
        ProductUse: true,
        PriceHistory: true,
        MaterialReceiveItem: true,
        MaterialRequestItem: true,
        PurchaseOrderItem: true,
        ReturnVoucherItem: true,
      },
    });

    return productVariant;
  }

  async updateProductVariant(
    productVariantId: string,
    updateData: UpdateProductVariantInput,
  ): Promise<ProductVariant> {
    const existingProductVariant = await this.prisma.productVariant.findUnique({
      where: { id: productVariantId },
    });

    if (!existingProductVariant) {
      throw new NotFoundException('Product variant not found');
    }

    const updatedProductVariant = await this.prisma.productVariant.update({
      where: { id: productVariantId },
      data: {
        ...updateData,
      },
      include: {
        product: true,
        WarehouseProduct: true,
        ProductUse: true,
        PriceHistory: true,
        MaterialReceiveItem: true,
        MaterialRequestItem: true,
        PurchaseOrderItem: true,
        ReturnVoucherItem: true,
      },
    });

    return updatedProductVariant;
  }

  async deleteProductVariant(productVariantId: string): Promise<void> {
    const existingProductVariant = await this.prisma.productVariant.findUnique({
      where: { id: productVariantId },
    });

    if (!existingProductVariant) {
      throw new NotFoundException('Product variant not found');
    }

    await this.prisma.productVariant.delete({
      where: { id: productVariantId },
    });
  }

  async count(where?: Prisma.ProductVariantWhereInput): Promise<number> {
    return this.prisma.productVariant.count({ where });
  }
}
