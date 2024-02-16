import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { ProjectService } from './project.service';
import { Project } from './model/project.model';
import { CreateProjectInput } from './dto/create-project.input';
import { UpdateProjectInput } from './dto/update-project.input';

@Resolver('Project')
export class ProjectResolver {
  constructor(private readonly projectService: ProjectService) {}

  @Query(() => [Project])
  async getProjects() {
    return this.projectService.findAll();
  }

  @Query(() => Project)
  async getProject(@Args('id', { type: () => String }) id: string) {
    return this.projectService.findOne(id);
  }

  @Mutation(() => Project)
  async createProject(
    @Args('createProjectInput') createProjectInput: CreateProjectInput,
  ) {
    return this.projectService.create(createProjectInput);
  }

  @Mutation(() => Project)
  async updateProject(
    @Args('id') projectId: string,
    @Args('updateProjectInput') updateProjectInput: UpdateProjectInput,
  ) {
    return this.projectService.update(projectId, updateProjectInput);
  }

  @Mutation(() => Project)
  async deleteProject(@Args('id', { type: () => String }) id: string) {
    return this.projectService.remove(id);
  }
}
