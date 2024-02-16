import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateProjectInput } from './dto/create-project.input';
import { Project } from './model/project.model';
import { UpdateProjectInput } from './dto/update-project.input';

@Injectable()
export class ProjectService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createProjectInput: CreateProjectInput): Promise<Project> {
    const existingProject = await this.prisma.project.findUnique({
      where: { name: createProjectInput.name },
    });

    if (existingProject) {
      throw new BadRequestException('Project already exists!');
    }

    const newProject = await this.prisma.project.create({
      data: {
        ...createProjectInput,
      },
    });

    return newProject;
  }

  async findAll(): Promise<Project[]> {
    const projects = await this.prisma.project.findMany({
      include: {
        client: true,
        projectManager: true,
        Milestones: true,
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
        client: true,
        projectManager: true,
        Milestones: true,
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
}
