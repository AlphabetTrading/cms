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
        companyId_name_location: {
          companyId: createWarehouseStore.companyId,
          name: createWarehouseStore.name,
          location: createWarehouseStore.location,
        },
      },
    });

    if (existingWarehouseStore) {
      throw new BadRequestException('Warehouse Store already exists!');
    }

    const { warehouseStoreManagerIds, ...warehouseStoreData } =
      createWarehouseStore;

    const createdWarehouseStore = await this.prisma.warehouseStore.create({
      data: {
        ...warehouseStoreData,
      },
    });

    if (warehouseStoreManagerIds && warehouseStoreManagerIds.length > 0) {
      await this.prisma.warehouseStoreManager.createMany({
        data: warehouseStoreManagerIds.map((manager) => ({
          warehouseStoreId: createdWarehouseStore.id,
          storeManagerId: manager.storeManagerId,
        })),
      });

      const updatedWarehouseStore = await this.prisma.warehouseStore.findUnique(
        {
          where: { id: createdWarehouseStore.id },
          include: {
            company: true,
            warehouseStoreManagers: {
              include: {
                StoreManager: true,
              },
            },
          },
        },
      );

      return updatedWarehouseStore;
    }

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
        warehouseStoreManagers: {
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
        warehouseStoreManagers: {
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
        warehouseStoreManagers: true,
      },
    });

    if (!existingWarehouseStore) {
      throw new NotFoundException('Warehouse store not found');
    }

    const { warehouseStoreManagerIds, ...warehouseStoreData } = updateData;

    const updatedWarehouseStore = await this.prisma.warehouseStore.update({
      where: { id: warehouseStoreId },
      data: {
        ...warehouseStoreData,
      },
    });

    if (warehouseStoreManagerIds) {
      const existingManagerIds =
        existingWarehouseStore.warehouseStoreManagers.map(
          (manager) => manager.storeManagerId,
        );
      const newManagerIds = warehouseStoreManagerIds.map(
        (manager) => manager.storeManagerId,
      );

      const managersToAdd = newManagerIds.filter(
        (id) => !existingManagerIds.includes(id),
      );

      const managersToRemove = existingManagerIds.filter(
        (id) => !newManagerIds.includes(id),
      );

      try {
        if (managersToAdd.length > 0) {
          await this.prisma.warehouseStoreManager.createMany({
            data: managersToAdd.map((storeManagerId) => ({
              warehouseStoreId: updatedWarehouseStore.id,
              storeManagerId,
            })),
          });
        }

        if (managersToRemove.length > 0) {
          await this.prisma.warehouseStoreManager.deleteMany({
            where: {
              warehouseStoreId: updatedWarehouseStore.id,
              storeManagerId: { in: managersToRemove },
            },
          });
        }
      } catch (error) {
        console.error('Error updating warehouse store managers:', error);
        throw new BadRequestException(
          'An error occurred while updating warehouse store managers. Please try again.',
        );
      }
    }

    const refreshedWarehouseStore = await this.prisma.warehouseStore.findUnique(
      {
        where: { id: updatedWarehouseStore.id },
        include: {
          company: true,
          warehouseStoreManagers: {
            include: {
              StoreManager: true,
            },
          },
        },
      },
    );

    return refreshedWarehouseStore;
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
