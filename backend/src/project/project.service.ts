import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateProjectInput } from './dto/create-project.input';
import { Project } from './model/project.model';
import { UpdateProjectInput } from './dto/update-project.input';
import { Prisma } from '@prisma/client';

@Injectable()
export class ProjectService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createProjectInput: CreateProjectInput): Promise<Project> {
    const existingProject = await this.prisma.project.findUnique({
      where: {
        companyId_name: {
          companyId: createProjectInput.companyId,
          name: createProjectInput.name,
        },
      },
    });

    if (existingProject) {
      throw new BadRequestException('Project already exists!');
    }

    const newProject = await this.prisma.project.create({
      data: {
        ...createProjectInput,
      },
      include: {
        company: {
          include: {
            employees: true,
            owner: true,
          },
        },
        Milestones: true,
        ProjectUsers: {
          include: {
            user: {
              include: {
                company: true,
              },
            },
            project: {
              include: {
                company: true,
              },
            },
          },
        },
      },
    });

    return newProject;
  }

  async findAll({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.ProjectWhereInput;
    orderBy?: Prisma.ProjectOrderByWithRelationInput;
  }): Promise<Project[]> {
    const projects = await this.prisma.project.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        company: {
          include: {
            employees: true,
            owner: true,
          },
        },
        Milestones: true,
        ProjectUsers: {
          include: {
            user: {
              include: {
                company: true,
              },
            },
            project: {
              include: {
                company: true,
              },
            },
          },
        },
      },
    });
    return projects;
  }

  async findOne(id: string): Promise<Project> {
    const project = await this.prisma.project.findUnique({
      where: {
        id,
      },
      include: {
        company: {
          include: {
            employees: true,
            owner: true,
          },
        },
        Milestones: true,
        ProjectUsers: {
          include: {
            user: {
              include: {
                company: true,
              },
            },
            project: {
              include: {
                company: true,
              },
            },
          },
        },
      },
    });
    return project;
  }

  async update(id: string, updateData: UpdateProjectInput): Promise<Project> {
    const existingProject = await this.prisma.project.findUnique({
      where: { id: id },
    });

    if (!existingProject) {
      throw new NotFoundException('Project not found');
    }

    const updatedProject = await this.prisma.project.update({
      where: { id },
      data: {
        ...updateData,
      },
      include: {
        company: {
          include: {
            employees: true,
            owner: true,
          },
        },
        Milestones: true,
        ProjectUsers: {
          include: {
            user: {
              include: {
                company: true,
              },
            },
            project: {
              include: {
                company: true,
              },
            },
          },
        },
      },
    });

    return updatedProject;
  }

  async remove(id: string): Promise<void> {
    const existingProject = await this.prisma.project.findUnique({
      where: { id: id },
    });

    if (!existingProject) {
      throw new NotFoundException('Project not found');
    }

    await this.prisma.materialReturnVoucher.delete({
      where: { id },
    });
  }

  async count(where?: Prisma.ProjectWhereInput): Promise<number> {
    return this.prisma.project.count({ where });
  }
}
