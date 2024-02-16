import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { Task } from './model/task.model';
import { TaskService } from './task.service';
import { CreateTaskInput } from './dto/create-task.input';
import { UpdateTaskInput } from './dto/update-task.input';

@Resolver('Task')
export class TaskResolver {
  constructor(private readonly taskService: TaskService) {}

  @Query(() => [Task])
  async getTasks() {
    return this.taskService.findAll();
  }

  @Query(() => Task)
  async getTask(@Args('id', { type: () => String }) id: string) {
    return this.taskService.findOne(id);
  }

  @Mutation(() => Task)
  async createTask(@Args('createTaskInput') createTaskInput: CreateTaskInput) {
    return this.taskService.create(createTaskInput);
  }

  @Mutation(() => Task)
  async updateTask(
    @Args('id') taskId: string,
    @Args('updateTaskInput') updateTaskInput: UpdateTaskInput,
  ) {
    return this.taskService.update(taskId, updateTaskInput);
  }

  @Mutation(() => Task)
  async deleteTask(@Args('id', { type: () => String }) id: string) {
    return this.taskService.remove(id);
  }
}
