import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { ProjectService } from './project.service';
import { Project } from './model/project.model';
import { CreateProjectInput } from './dto/create-project.input';
import { UpdateProjectInput } from './dto/update-project.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { FilterProjectInput } from './dto/filter-project.input';
import { OrderByProjectInput } from './dto/order-by-project.input';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { PaginationProjects } from 'src/common/pagination/pagination-info';
import { Prisma } from '@prisma/client';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';
import { RolesGuard } from 'src/auth/guards/roles.guard';
import { HasRoles } from 'src/common/decorators';

@UseGuards(GqlAuthGuard, RolesGuard)
@Resolver('Project')
export class ProjectResolver {
  constructor(private readonly projectService: ProjectService) {}

  @Query(() => PaginationProjects)
  async getProjects(
    @Args('filterProjectInput', {
      type: () => FilterProjectInput,
      nullable: true,
    })
    filterProjectInput?: FilterProjectInput,
    @Args('orderBy', {
      type: () => OrderByProjectInput,
      nullable: true,
    })
    orderBy?: OrderByProjectInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ) {
    const where: Prisma.ProjectWhereInput = {
      AND: [
        {
          id: filterProjectInput?.id,
        },
        {
          OR: [
            {
              name: filterProjectInput?.name,
            },
            {
              startDate: filterProjectInput?.startDate,
            },
            {
              endDate: filterProjectInput?.endDate,
            },
            {
              companyId: filterProjectInput?.companyId,
            },
            {
              company: filterProjectInput?.company,
            },
            {
              budget: filterProjectInput?.budget,
            },
            {
              status: filterProjectInput?.status,
            },
          ],
        },
        {
          createdAt: filterProjectInput?.createdAt,
        },
      ],
    };

    try {
      const projects = await this.projectService.findAll({
        where,
        orderBy,
        skip: paginationInput?.skip,
        take: paginationInput?.take,
      });

      const count = await this.projectService.count(where);

      return {
        items: projects,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      console.log(e, 'ERROR');
      throw new BadRequestException('Error loading projects!');
    }
  }

  @Query(() => Project)
  async getProject(@Args('id', { type: () => String }) id: string) {
    try {
      return this.projectService.findOne(id);
    } catch (e) {
      throw new BadRequestException('Error loading project!');
    }
  }

  @Mutation(() => Project)
  @HasRoles('OWNER', 'ADMIN')
  async createProject(
    @Args('createProjectInput') createProjectInput: CreateProjectInput,
  ) {
    try {
      return this.projectService.create(createProjectInput);
    } catch (e) {
      throw new BadRequestException('Error creating project!');
    }
  }

  @Mutation(() => Project)
  @HasRoles('OWNER', 'ADMIN')
  async updateProject(
    @Args('id') projectId: string,
    @Args('updateProjectInput') updateProjectInput: UpdateProjectInput,
  ) {
    try {
      return this.projectService.update(projectId, updateProjectInput);
    } catch (e) {
      throw new BadRequestException('Error updating project!');
    }
  }

  @Mutation(() => Project)
  @HasRoles('OWNER', 'ADMIN')
  async deleteProject(@Args('id', { type: () => String }) id: string) {
    try {
      return this.projectService.remove(id);
    } catch (e) {
      throw new BadRequestException('Error deleting project!');
    }
  }
}
