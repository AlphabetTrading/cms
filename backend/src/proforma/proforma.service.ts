import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { Prisma } from '@prisma/client';
import { CreateProformaInput } from './dto/create-proforma.input';
import { Proforma } from './model/proforma.model';
import { UpdateProformaInput } from './dto/update-proforma.input';

@Injectable()
export class ProformaService {
  constructor(private prisma: PrismaService) {}

  async createProforma(
    createProformaInput: CreateProformaInput,
  ): Promise<Proforma> {
    const lastProforma =
      await this.prisma.proforma.findFirst({
        select: {
          serialNumber: true,
        },
        orderBy: {
          createdAt: 'desc',
        },
      });
    let currentSerialNumber = 1;
    if (lastProforma) {
      currentSerialNumber =
        parseInt(lastProforma.serialNumber.split('/')[1]) + 1;
    }
    const serialNumber =
      'PRO/' + currentSerialNumber.toString().padStart(4, '0');

    const createdProforma = await this.prisma.proforma.create({
      data: {
        ...createProformaInput,
        serialNumber: serialNumber,
      },
    });
    return createdProforma;
  }

  async getProformas({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.ProformaWhereInput;
    orderBy?: Prisma.ProformaOrderByWithRelationInput;
  }): Promise<Proforma[]> {
    const proformas = await this.prisma.proforma.findMany({
      skip,
      take,
      where,
      orderBy,
    });
    return proformas;
  }

  async getProformaById(proformaId: string): Promise<Proforma | null> {
    const proforma = await this.prisma.proforma.findUnique({
      where: { id: proformaId },
    });

    return proforma;
  }

  async updateProforma(
    proformaId: string,
    updateData: UpdateProformaInput,
  ): Promise<Proforma> {
    const existingProforma = await this.prisma.proforma.findUnique({
      where: { id: proformaId },
    });

    if (!existingProforma) {
      throw new NotFoundException('Proforma not found');
    }

    const updatedProforma = await this.prisma.proforma.update({
      where: { id: proformaId },
      data: {
        ...updateData,
      },
    });

    return updatedProforma;
  }

  async deleteProforma(proformaId: string): Promise<void> {
    const existingProforma = await this.prisma.proforma.findUnique({
      where: { id: proformaId },
    });

    if (!existingProforma) {
      throw new NotFoundException('Proforma not found');
    }

    await this.prisma.proforma.delete({
      where: { id: proformaId },
    });
  }

  async count(where?: Prisma.ProformaWhereInput): Promise<number> {
    return this.prisma.proforma.count({ where });
  }
}
