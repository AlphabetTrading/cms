import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { Prisma, Product } from '@prisma/client';
import { CreateProductInput } from './dto/create-product.input';
import { UpdateProductInput } from './dto/update-product.input';

@Injectable()
export class ProductService {
  constructor(private prisma: PrismaService) {}

  async createProduct(createProduct: CreateProductInput): Promise<Product> {
    const existingProduct = await this.prisma.product.findUnique({
      where: {
        name: createProduct.name,
      },
    });

    if (existingProduct) {
      throw new BadRequestException('Product already exists!');
    }

    const createdProduct = await this.prisma.product.create({
      data: {
        ...createProduct
      }
    });

    return createdProduct;
  }

  async getProducts({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.ProductWhereInput;
    orderBy?: Prisma.ProductOrderByWithRelationInput;
  }): Promise<Product[]> {
    const products = await this.prisma.product.findMany({
      skip,
      take,
      where,
      orderBy,
    });
    return products;
  }

  async getProductById(productId: string): Promise<Product | null> {
    const product = await this.prisma.product.findUnique({
      where: { id: productId },
    });

    return product;
  }

  async updateProduct(
    productId: string,
    updateData: UpdateProductInput,
  ): Promise<Product> {
    const existingProduct = await this.prisma.product.findUnique({
      where: { id: productId },
    });

    if (!existingProduct) {
      throw new NotFoundException('Product not found');
    }

    const updatedProduct = await this.prisma.product.update({
      where: { id: productId },
      data: {
        ...updateData,
      },
    });

    return updatedProduct;
  }

  async deleteProduct(productId: string): Promise<void> {
    const existingProduct = await this.prisma.product.findUnique({
      where: { id: productId },
    });

    if (!existingProduct) {
      throw new NotFoundException('Product not found');
    }

    await this.prisma.product.delete({
      where: { id: productId },
    });
  }

  async count(where?: Prisma.ProductWhereInput): Promise<number> {
    return this.prisma.product.count({ where });
  }
}
