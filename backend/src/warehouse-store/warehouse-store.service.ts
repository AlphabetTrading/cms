import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { Prisma, WarehouseStore } from '@prisma/client';
import { CreateWarehouseStoreInput } from './dto/create-warehouse-store.input';
import { UpdateWarehouseStoreInput } from './dto/update-warehouse-store.input';

@Injectable()
export class WarehouseStoreService {
  constructor(private prisma: PrismaService) {}

  async createWarehouseStore(
    createWarehouseStore: CreateWarehouseStoreInput,
  ): Promise<WarehouseStore> {
    const existingWarehouseStore = await this.prisma.warehouseStore.findUnique({
      where: {
        name_location: {
          name: createWarehouseStore.name,
          location: createWarehouseStore.location,
        },
      },
    });

    if (existingWarehouseStore) {
      throw new BadRequestException('Warehouse Store already exists!');
    }

    const createdWarehouseStore = await this.prisma.warehouseStore.create({
      data: {
        ...createWarehouseStore,
      },
      include: {
        company: true,
        WarehouseStoreManager: {
          include: {
            StoreManager: true,
          },
        },
      },
    });

    return createdWarehouseStore;
  }

  async getWarehouseStores({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.WarehouseStoreWhereInput;
    orderBy?: Prisma.WarehouseStoreOrderByWithRelationInput;
  }): Promise<WarehouseStore[]> {
    const warehouseStores = await this.prisma.warehouseStore.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        company: true,
        WarehouseStoreManager: {
          include: {
            StoreManager: true,
          },
        },
      },
    });
    return warehouseStores;
  }

  async getWarehouseStoreById(
    warehouseStoreId: string,
  ): Promise<WarehouseStore | null> {
    const warehouseStore = await this.prisma.warehouseStore.findUnique({
      where: { id: warehouseStoreId },
      include: {
        company: true,
        WarehouseStoreManager: {
          include: {
            StoreManager: true,
          },
        },
      },
    });

    return warehouseStore;
  }

  async updateWarehouseStore(
    warehouseStoreId: string,
    updateData: UpdateWarehouseStoreInput,
  ): Promise<WarehouseStore> {
    const existingWarehouseStore = await this.prisma.warehouseStore.findUnique({
      where: { id: warehouseStoreId },
      include: {
        company: true,
        WarehouseStoreManager: {
          include: {
            StoreManager: true,
          },
        },
      },
    });

    if (!existingWarehouseStore) {
      throw new NotFoundException('Warehouse store not found');
    }

    const updatedWarehouseStore = await this.prisma.warehouseStore.update({
      where: { id: warehouseStoreId },
      data: {
        ...updateData,
      },
    });

    return updatedWarehouseStore;
  }

  async deleteWarehouseStore(warehouseStoreId: string): Promise<void> {
    const existingWarehouseStore = await this.prisma.warehouseStore.findUnique({
      where: { id: warehouseStoreId },
    });

    if (!existingWarehouseStore) {
      throw new NotFoundException('Warehouse store not found');
    }

    await this.prisma.warehouseStore.delete({
      where: { id: warehouseStoreId },
    });
  }

  async count(where?: Prisma.WarehouseStoreWhereInput): Promise<number> {
    return this.prisma.warehouseStore.count({ where });
  }
}
