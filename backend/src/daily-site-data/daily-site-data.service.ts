import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { ApprovalStatus, Prisma } from '@prisma/client';
import { DailySiteData } from './model/daily-site-data.model';
import { CreateDailySiteDataInput } from './dto/create-daily-site-data.input';
import { CreateDailySiteDataTaskLaborInput } from './dto/create-daily-site-data-task-labor.input';
import { CreateDailySiteDataTaskMaterialInput } from './dto/create-daily-site-data-task-material.input';
import { UpdateDailySiteDataInput } from './dto/update-daily-site-data.input';

@Injectable()
export class DailySiteDataService {
  constructor(private prisma: PrismaService) {}

  async createDailySiteData(
    createDailySiteDataInput: CreateDailySiteDataInput,
  ): Promise<DailySiteData> {
    return await this.prisma.$transaction(async (prisma) => {
      const createdDailySiteData = await prisma.dailySiteData.create({
        data: {
          ...createDailySiteDataInput,
          tasks: {
            create: createDailySiteDataInput.tasks.map((task) => ({
              ...task,
              laborDetails: {
                create: task.laborDetails.map(
                  (labor: CreateDailySiteDataTaskLaborInput) => ({
                    ...labor,
                  }),
                ),
              },
              materialDetails: {
                create: task.materialDetails.map(
                  (material: CreateDailySiteDataTaskMaterialInput) => ({
                    ...material,
                  }),
                ),
              },
            })),
          },
        },
        include: {
          tasks: {
            include: {
              laborDetails: true,
              materialDetails: true,
            },
          },
          Project: true,
          approvedBy: true,
          checkedBy: true,
          preparedBy: true,
        },
      });
      return createdDailySiteData;
    });
  }

  async getDailySiteDatas({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.DailySiteDataWhereInput;
    orderBy?: Prisma.DailySiteDataOrderByWithRelationInput;
  }): Promise<DailySiteData[]> {
    const dailySiteDatas = await this.prisma.dailySiteData.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        tasks: {
          include: {
            laborDetails: true,
            materialDetails: {
              include: {
                productVariant: true
              }
            },
          },
        },
        Project: true,
        approvedBy: true,
        checkedBy: true,
        preparedBy: true,
      },
    });
    return dailySiteDatas;
  }

  async getDailySiteDataById(
    dailySiteDataId: string,
  ): Promise<DailySiteData | null> {
    const dailySiteData = await this.prisma.dailySiteData.findUnique({
      where: { id: dailySiteDataId },
      include: {
        tasks: {
          include: {
            laborDetails: true,
            materialDetails: {
              include: {
                productVariant: true
              }
            },
          },
        },
        Project: true,
        approvedBy: true,
        checkedBy: true,
        preparedBy: true,
      },
    });

    return dailySiteData;
  }

  async updateDailySiteData(
    input: UpdateDailySiteDataInput,
  ): Promise<DailySiteData> {
    const { id: dailySiteDataId, tasks, ...dailySiteDataInput } = input;

    return await this.prisma.$transaction(async (prisma) => {
      const existingDailySiteData = await prisma.dailySiteData.findUnique({
        where: { id: dailySiteDataId },
      });

      if (!existingDailySiteData) {
        throw new NotFoundException('Daily Site Data not found');
      }

      const taskUpdateConditions = tasks.map((task) => ({
        id: task.id,
      }));

      const updateData = {
        ...dailySiteDataInput,
        tasks: {
          updateMany: tasks?.map((task) => ({
            where: {
              OR: taskUpdateConditions,
            },
            data: {
              ...task,
              laborDetails: task.laborDetails
                ? {
                    updateMany: task.laborDetails.map((labor) => ({
                      where: { id: labor.id },
                      data: labor,
                    })),
                  }
                : undefined,
              materialDetails: task.materialDetails
                ? {
                    updateMany: task.materialDetails.map((material) => ({
                      where: { id: material.id },
                      data: material,
                    })),
                  }
                : undefined,
            },
          })),
        },
      };

      const updatedDailySiteData = await prisma.dailySiteData.update({
        where: { id: dailySiteDataId },
        data: updateData,
        include: {
          tasks: {
            include: {
              laborDetails: true,
              materialDetails: {
                include: {
                  productVariant: true
                }
              },
            },
          },
          Project: true,
          approvedBy: true,
          checkedBy: true,
          preparedBy: true,
        },
        });
      return updatedDailySiteData;
    });
  }

  async deleteDailySiteData(dailySiteDataId: string): Promise<DailySiteData> {
    const existingDailySiteData = await this.prisma.dailySiteData.findUnique({
      where: { id: dailySiteDataId },
    });

    if (!existingDailySiteData) {
      throw new NotFoundException('Daily Site Data not found');
    }

    await this.prisma.dailySiteData.delete({
      where: { id: dailySiteDataId },
    });

    return existingDailySiteData;
  }

  async getDailySiteDataApprovers(projectId?: string) {
    const approvers = await this.prisma.project.findMany({
      where: {
        id: projectId,
      },
      select: {
        ProjectManager: true,
      },
    });
    return approvers;
  }

  async approveDailySiteData(
    dailySiteDataId: string,
    userId: string,
    status: ApprovalStatus,
  ): Promise<DailySiteData> {
    const dailySiteData = await this.prisma.dailySiteData.findUnique(
      {
        where: { id: dailySiteDataId },
      },
    );

    if (!dailySiteData) {
      throw new NotFoundException('Daily Site Data not found');
    }

    if (dailySiteData.approvedById) {
      throw new NotFoundException('Already decided on this daily site data!');
    }

    const updatedDailySiteData =
      await this.prisma.dailySiteData.update({
        where: { id: dailySiteDataId },
        data: {
          approvedById: userId,
          status: status,
        },
      });

    return updatedDailySiteData;
  }

  async count(where?: Prisma.DailySiteDataWhereInput): Promise<number> {
    return this.prisma.dailySiteData.count({ where });
  }
}
