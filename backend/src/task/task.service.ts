import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateTaskInput } from './dto/create-task.input';
import { Task } from './model/task.model';
import { UpdateTaskInput } from './dto/update-task.input';
import { Prisma } from '@prisma/client';

@Injectable()
export class TaskService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createTaskInput: CreateTaskInput): Promise<Task> {
    const existingTask = await this.prisma.task.findUnique({
      where: {
        name_milestoneId: {
          name: createTaskInput.name,
          milestoneId: createTaskInput.milestoneId,
        },
      },
    });

    if (existingTask) {
      throw new BadRequestException('Task already exists!');
    }

    const newTask = await this.prisma.task.create({
      data: {
        ...createTaskInput,
      },
    });

    return newTask;
  }

  async findAll({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.TaskWhereInput;
    orderBy?: Prisma.TaskOrderByWithRelationInput;
  }): Promise<Task[]> {
    const tasks = await this.prisma.task.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        Milestone: true,
        assignedTo: true,
      },
    });
    return tasks;
  }

  async findOne(id: string): Promise<Task> {
    const task = await this.prisma.task.findUnique({
      where: {
        id,
      },
      include: {
        Milestone: true,
        assignedTo: true,
      },
    });
    return task;
  }

  async update(id: string, updateData: UpdateTaskInput): Promise<Task> {
    const existingTask = await this.prisma.task.findUnique({
      where: { id: id },
    });

    if (!existingTask) {
      throw new NotFoundException('Task not found');
    }

    const updatedTask = await this.prisma.task.update({
      where: { id },
      data: {
        ...updateData,
      },
      include: {
        assignedTo: true,
        Milestone: true
      }
    });

    return updatedTask;
  }

  async remove(id: string): Promise<void> {
    const existingTask = await this.prisma.task.findUnique({
      where: { id: id },
    });

    if (!existingTask) {
      throw new NotFoundException('Task not found');
    }

    await this.prisma.materialReturnVoucher.delete({
      where: { id },
    });
  }

  async count(where?: Prisma.TaskWhereInput): Promise<number> {
    return this.prisma.task.count({ where });
  }
}
