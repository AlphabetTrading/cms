import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateMilestoneInput } from './dto/create-milestone.input';
import { Milestone } from './model/milestone.model';
import { UpdateMilestoneInput } from './dto/update-milestone.input';
import { Prisma } from '@prisma/client';

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
        Tasks: true,
        Project: true,
      },
    });
    return milestones;
  }

  async findOne(id: string): Promise<Milestone> {
    const milestone = await this.prisma.milestone.findUnique({
      where: {
        id,
      },
      include: {
        Tasks: true,
        Project: true,
      },
    });
    return milestone;
  }

  async update(
    id: string,
    updateData: UpdateMilestoneInput,
  ): Promise<Milestone> {
    const existingMilestone = await this.prisma.milestone.findUnique({
      where: { id: id },
    });

    if (!existingMilestone) {
      throw new NotFoundException('Milestone not found');
    }

    const updatedMilestone = await this.prisma.milestone.update({
      where: { id },
      data: {
        ...updateData,
      },
    });

    return updatedMilestone;
  }

  async remove(id: string): Promise<void> {
    const existingMilestone = await this.prisma.milestone.findUnique({
      where: { id: id },
    });

    if (!existingMilestone) {
      throw new NotFoundException('Milestone not found');
    }

    await this.prisma.materialReturnVoucher.delete({
      where: { id },
    });
  }

  async count(where?: Prisma.MilestoneWhereInput): Promise<number> {
    return this.prisma.milestone.count({ where });
  }
}
