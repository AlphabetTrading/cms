import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { Company, Prisma } from '@prisma/client';
import { CreateCompanyInput } from 'src/company/dto/create-company.input';
import { UpdateCompanyInput } from 'src/company/dto/update-company.input';

@Injectable()
export class CompanyService {
  constructor(private readonly prisma: PrismaService) {}

  async createCompany(
    createCompanyInput: CreateCompanyInput,
  ): Promise<Company> {
    const existingCompany = await this.prisma.company.findUnique({
      where: {
        name: createCompanyInput.name,
        address: createCompanyInput.address,
        ownerId: createCompanyInput.ownerId,
      },
    });

    if (existingCompany) {
      throw new BadRequestException('Company already exists!');
    }

    const newCompany = await this.prisma.company.create({
      data: {
        ...createCompanyInput,
      },
      include: {
        employees: true,
        owner: true,
        projects: true,
        warehouseStores: true,
      },
    });

    return newCompany;
  }

  async getAllCompanies({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.CompanyWhereInput;
    orderBy?: Prisma.CompanyOrderByWithRelationInput;
  }): Promise<Company[]> {
    const companies = await this.prisma.company.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        employees: true,
        owner: true,
        projects: true,
        warehouseStores: true,
      },
    });
    return companies;
  }

  async getCompanyById(id: string): Promise<Company> {
    const company = await this.prisma.company.findUnique({
      where: {
        id,
      },
      include: {
        employees: true,
        owner: true,
        projects: true,
        warehouseStores: true,
      },
    });
    return company;
  }

  async updateCompany(
    id: string,
    updateData: UpdateCompanyInput,
  ): Promise<Company> {
    const existingCompany = await this.prisma.company.findUnique({
      where: { id: id },
    });

    if (!existingCompany) {
      throw new NotFoundException('Company not found');
    }

    const updatedCompany = await this.prisma.company.update({
      where: { id },
      data: {
        ...updateData,
      },
    });

    return updatedCompany;
  }

  async deleteCompany(id: string): Promise<Company> {
    const existingCompany = await this.prisma.company.findUnique({
      where: { id: id },
    });

    if (!existingCompany) {
      throw new NotFoundException('Company not found');
    }

    await this.prisma.materialReturnVoucher.delete({
      where: { id },
    });

    return existingCompany;
  }

  async count(where?: Prisma.CompanyWhereInput): Promise<number> {
    return this.prisma.company.count({ where });
  }
}
