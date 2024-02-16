import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { Task } from './model/task.model';
import { TaskService } from './task.service';
import { CreateTaskInput } from './dto/create-task.input';
import { UpdateTaskInput } from './dto/update-task.input';
import { BadRequestException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { FilterTaskInput } from './dto/filter-task.input';
import { OrderByTaskInput } from './dto/order-by-task.input';
import { PaginationTasks } from 'src/common/pagination/pagination-info';

@Resolver('Task')
export class TaskResolver {
  constructor(private readonly taskService: TaskService) {}

  @Query(() => PaginationTasks)
  async getTasks(
    @Args('filterTaskInput', {
      type: () => FilterTaskInput,
      nullable: true,
    })
    filterTaskInput?: FilterTaskInput,
    @Args('orderBy', {
      type: () => OrderByTaskInput,
      nullable: true,
    })
    orderBy?: OrderByTaskInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ) {
    const where: Prisma.TaskWhereInput = {
      AND: [
        {
          id: filterTaskInput?.id,
        },
        {
          OR: [
            {
              name: filterTaskInput?.name,
            },
            {
              startDate: filterTaskInput?.startDate,
            },
            {
              dueDate: filterTaskInput?.dueDate,
            },
            {
              assignedToId: filterTaskInput?.assignedToId,
            },
            {
              milestoneId: filterTaskInput?.milestoneId,
            },
            {
              priority: filterTaskInput?.priority,
            },
            {
              status: filterTaskInput?.status,
            },
          ],
        },
        {
          createdAt: filterTaskInput?.createdAt,
        },
      ],
    };

    try {
      const tasks = await this.taskService.findAll({
        where,
        orderBy,
        skip: paginationInput?.skip,
        take: paginationInput?.take,
      });

      const count = await this.taskService.count(where);

      return {
        items: tasks,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading tasks!');
    }
  }

  @Query(() => Task)
  async getTask(@Args('id', { type: () => String }) id: string) {
    try {
      return this.taskService.findOne(id);
    } catch (e) {
      throw new BadRequestException('Error loading task!');
    }
  }

  @Mutation(() => Task)
  async createTask(@Args('createTaskInput') createTaskInput: CreateTaskInput) {
    try {
      return this.taskService.create(createTaskInput);
    } catch (e) {
      throw new BadRequestException('Error creating task!');
    }
  }

  @Mutation(() => Task)
  async updateTask(
    @Args('id') taskId: string,
    @Args('updateTaskInput') updateTaskInput: UpdateTaskInput,
  ) {
    try {
      return this.taskService.update(taskId, updateTaskInput);
    } catch (e) {
      throw new BadRequestException('Error updating task!');
    }
  }

  @Mutation(() => Task)
  async deleteTask(@Args('id', { type: () => String }) id: string) {
    try {
      return this.taskService.remove(id);
    } catch (e) {
      throw new BadRequestException('Error deleting task!');
    }
  }
}
