import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { Prisma, UserRole } from '@prisma/client';
import { CreateProformaInput } from './dto/create-proforma.input';
import { Proforma } from './model/proforma.model';
import { UpdateProformaInput } from './dto/update-proforma.input';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';
import { DocumentType } from 'src/common/enums/document-type';
import { StorageResolver } from 'src/storage/storage.resolver';

@Injectable()
export class ProformaService {
  constructor(
    private prisma: PrismaService,
    private readonly storageResolver: StorageResolver,
  ) {}

  async createProforma(
    createProformaInput: CreateProformaInput,
  ): Promise<Proforma> {
    const lastProforma = await this.prisma.proforma.findFirst({
      select: {
        serialNumber: true,
      },
      orderBy: {
        serialNumber: 'desc',
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
        items: {
          create: createProformaInput.items.map((item) => ({
            photo: item.photo,
            vendor: item.vendor,
            unitPrice: item.unitPrice,
            totalPrice: item.totalPrice,
            quantity: item.quantity,
            remark: item.remark,
          })),
        },
      },
      include: {
        items: true,
        selectedProformaItem: true,
        materialRequestItem: {
          include: {
            MaterialRequestVoucher: true,
            productVariant: {
              include: {
                product: true,
              },
            },
          },
        },
        approvedBy: true,
        preparedBy: true,
        Project: true,
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
      include: {
        items: true,
        selectedProformaItem: true,
        materialRequestItem: {
          include: {
            MaterialRequestVoucher: true,
            productVariant: {
              include: {
                product: true,
              },
            },
          },
        },
        approvedBy: true,
        preparedBy: true,
        Project: true,
      },
    });
    return proformas;
  }

  async getProformaCountByStatus({
    where,
  }: {
    where?: Prisma.ProformaWhereInput;
  }): Promise<any> {
    const statusCounts = await this.prisma.proforma.groupBy({
      by: ['status'],
      where,
      _count: {
        status: true,
      },
    });

    let counts = { COMPLETED: 0, DECLINED: 0, PENDING: 0 };

    counts = statusCounts.reduce((acc, { status, _count }) => {
      acc[status] = _count.status;
      return acc;
    }, counts);

    const documentTransaction = new DocumentTransaction();
    documentTransaction.approvedCount = counts.COMPLETED;
    documentTransaction.declinedCount = counts.DECLINED;
    documentTransaction.pendingCount = counts.PENDING;
    documentTransaction.type = DocumentType.PROFORMA;

    return documentTransaction;
  }

  async getProformaById(proformaId: string): Promise<Proforma | null> {
    const proforma = await this.prisma.proforma.findUnique({
      where: { id: proformaId },
      include: {
        items: true,
        selectedProformaItem: true,
        materialRequestItem: {
          include: {
            MaterialRequestVoucher: true,
            productVariant: {
              include: {
                product: true,
              },
            },
          },
        },
        approvedBy: true,
        preparedBy: true,
        Project: true,
      },
    });

    return proforma;
  }

  async updateProforma(input: UpdateProformaInput): Promise<Proforma> {
    const { id: proformaId, ...updateData } = input;

    return await this.prisma.$transaction(async (prisma) => {
      const existingProforma = await prisma.proforma.findUnique({
        where: { id: proformaId },
      });

      if (!existingProforma) {
        throw new NotFoundException('Proforma not found');
      }

      const updatedItems = await Promise.all(
        updateData.items.map(async (item) => {
          let newPhotoUrl: string | undefined;

          if (item.id) {
            if (item.photo) {
              newPhotoUrl = item.photo;
              const existingItem = await this.prisma.proformaItem.findUnique({
                where: { id: item.id },
              });

              if (existingItem && existingItem.photo) {
                await this.storageResolver.deleteFile(existingItem.photo);
              }

              return { ...item, photo: newPhotoUrl };
            }
          }

          return item;
        }),
      );

      const updatePayload: Prisma.ProformaUpdateInput = {
        ...updateData,
        items: {
          update: updatedItems
            .filter((item) => item.id)
            .map((item) => ({
              where: { id: item.id },
              data: { ...item, newPhoto: undefined },
            })),
          create: updatedItems
            .filter((item) => !item.id)
            .map((item) => ({
              vendor: item.vendor,
              quantity: item.quantity,
              unitPrice: item.unitPrice,
              totalPrice: item.totalPrice,
              remark: item.remark,
              photo: item.photo,
            })),
        },
      };

      try {
        const updatedProforma = await prisma.proforma.update({
          where: { id: proformaId },
          data: updatePayload,
          include: {
            items: true,
            selectedProformaItem: true,
            materialRequestItem: {
              include: {
                MaterialRequestVoucher: true,
                productVariant: {
                  include: {
                    product: true,
                  },
                },
              },
            },
            approvedBy: true,
            preparedBy: true,
            Project: true,
          },
        });
        return updatedProforma;
      } catch (e) {
        throw new BadRequestException('Unable to update proforma!');
      }
    });
  }

  async deleteProforma(proformaId: string): Promise<Proforma> {
    const existingProforma = await this.prisma.proforma.findUnique({
      where: { id: proformaId },
    });

    if (!existingProforma) {
      throw new NotFoundException('Proforma not found');
    }

    await this.prisma.proforma.delete({
      where: { id: proformaId },
    });

    return existingProforma;
  }

  async getProformaApprovers(projectId?: string) {
    const approvers = await this.prisma.project.findMany({
      where: {
        id: projectId,
      },
      select: {
        ProjectUsers: {
          where: {
            user: {
              role: UserRole.PROJECT_MANAGER,
            },
          },
          select: {
            userId: true,
          },
        },
      },
    });
    return approvers;
  }

  async approveProforma(
    proformaId: string,
    userId: string,
    selectedProformaItemId: string,
  ): Promise<Proforma> {
    const proforma = await this.prisma.proforma.findUnique({
      where: { id: proformaId },
    });

    if (!proforma) {
      throw new NotFoundException('Proforma not found');
    }

    if (proforma.approvedById) {
      throw new NotFoundException('Already decided on this proforma!');
    }

    const updatedProforma = await this.prisma.proforma.update({
      where: { id: proformaId },
      data: {
        approvedById: userId,
        status: 'COMPLETED',
        selectedProformaItemId: selectedProformaItemId,
      },
      include: {
        items: true,
        selectedProformaItem: true,
        materialRequestItem: {
          include: {
            MaterialRequestVoucher: true,
            productVariant: {
              include: {
                product: true,
              },
            },
          },
        },
        approvedBy: true,
        preparedBy: true,
        Project: true,
      },
    });

    return updatedProforma;
  }

  async count(where?: Prisma.ProformaWhereInput): Promise<number> {
    return this.prisma.proforma.count({ where });
  }
}
