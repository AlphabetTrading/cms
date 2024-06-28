import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMilestoneInput } from './dto/create-milestone.input';
import { Milestone } from './model/milestone.model';
import { UpdateMilestoneInput } from './dto/update-milestone.input';
import { CompletionStatus, Prisma } from '@prisma/client';

@Injectable()
export class MilestoneService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createMilestoneInput: CreateMilestoneInput): Promise<Milestone> {
    const existingMilestone = await this.prisma.milestone.findUnique({
      where: {
        name_projectId: {
          name: createMilestoneInput.name,
          projectId: createMilestoneInput.projectId,
        },
      },
    });

    if (existingMilestone) {
      throw new BadRequestException('Milestone already exists!');
    }

    const newMilestone = await this.prisma.milestone.create({
      data: {
        ...createMilestoneInput,
      },
      include: {
        Project: true,
        Tasks: {
          include: {
            assignedTo: true,
          },
        },
        createdBy: true,
      },
    });

    return newMilestone;
  }

  async findAll({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.MilestoneWhereInput;
    orderBy?: Prisma.MilestoneOrderByWithRelationInput;
  }): Promise<Milestone[]> {
    const milestones = await this.prisma.milestone.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        Tasks: {
          include: {
            assignedTo: true,
          },
        },
        Project: true,
        createdBy: true,
      },
    });

    const milestonesWithProgress = milestones.map((milestone) => {
      const totalTasks = milestone.Tasks.length;
      const completedTasks = milestone.Tasks.filter(
        (task) => task.status === CompletionStatus.COMPLETED,
      ).length;
      const progress = totalTasks ? (completedTasks / totalTasks) * 100 : 0;

      return {
        ...milestone,
        progress,
      };
    });

    return milestonesWithProgress;
  }

  async findOne(id: string): Promise<Milestone> {
    const milestone = await this.prisma.milestone.findUnique({
      where: {
        id,
      },
      include: {
        Tasks: {
          include: {
            assignedTo: true,
          },
        },
        Project: true,
        createdBy: true,
      },
    });

    const totalTasks = milestone.Tasks.length;
    const completedTasks = milestone.Tasks.filter(
      (task) => task.status === CompletionStatus.COMPLETED,
    ).length;
    const progress = totalTasks ? (completedTasks / totalTasks) * 100 : 0;

    return {
      ...milestone,
      progress,
    };
  }

  async update(
    input: UpdateMilestoneInput,
  ): Promise<Milestone> {
    const { id: milestoneId, ...updateData } = input;

    const existingMilestone = await this.prisma.milestone.findUnique({
      where: { id: milestoneId },
    });

    if (!existingMilestone) {
      throw new NotFoundException('Milestone not found');
    }

    const updatedMilestone = await this.prisma.milestone.update({
      where: { id: milestoneId },
      data: {
        ...updateData,
      },
      include: {
        Project: true,
        Tasks: true,
        createdBy: true,
      },
    });

    const totalTasks = updatedMilestone.Tasks.length;
    const completedTasks = updatedMilestone.Tasks.filter(
      (task) => task.status === CompletionStatus.COMPLETED,
    ).length;
    const progress = totalTasks ? (completedTasks / totalTasks) * 100 : 0;

    return {
      ...updatedMilestone,
      progress,
    };
  }

  async remove(id: string): Promise<Milestone> {
    const existingMilestone = await this.prisma.milestone.findUnique({
      where: { id: id },
    });

    if (!existingMilestone) {
      throw new NotFoundException('Milestone not found');
    }

    await this.prisma.milestone.delete({
      where: { id },
    });

    return existingMilestone
  }

  async count(where?: Prisma.MilestoneWhereInput): Promise<number> {
    return this.prisma.milestone.count({ where });
  }
}
