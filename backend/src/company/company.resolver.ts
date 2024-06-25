import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { Prisma, User } from '@prisma/client';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';
import { UserEntity } from 'src/common/decorators';
import { CompanyService } from './company.service';
import { PaginationCompanies } from 'src/common/pagination/pagination-info';
import { FilterCompanyInput } from './dto/filter-company.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { CreateCompanyInput } from './dto/create-company.input';
import { OrderByCompanyInput } from './dto/order-by-company.input';
import { UpdateCompanyInput } from './dto/update-company.input';
import { Company } from './model/company.model';

@UseGuards(GqlAuthGuard)
@Resolver('Company')
export class CompanyResolver {
  constructor(private readonly companyService: CompanyService) {}

  @Query(() => PaginationCompanies)
  async getCompanies(
    @UserEntity() user: User,
    @Args('filterCompanyInput', {
      type: () => FilterCompanyInput,
      nullable: true,
    })
    filterCompanyInput?: FilterCompanyInput,
    @Args('orderBy', {
      type: () => OrderByCompanyInput,
      nullable: true,
    })
    orderBy?: OrderByCompanyInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ): Promise<PaginationCompanies> {
    const where: Prisma.CompanyWhereInput = {
      AND: [
        {
          id: filterCompanyInput?.id,
        },
        {
          OR: [
            {
              name: filterCompanyInput?.name,
            },
            {
              address: filterCompanyInput?.address,
            },
            {
              contactInfo: filterCompanyInput?.contactInfo,
            },
            {
              ownerId: filterCompanyInput?.ownerId,
            },
            {
              owner: filterCompanyInput?.owner,
            },
          ],
        },
        {
          createdAt: filterCompanyInput?.createdAt,
        },
      ],
    };

    try {
      const companies = await this.companyService.getAllCompanies({
        where,
        orderBy,
        skip: paginationInput?.skip,
        take: paginationInput?.take,
      });

      const count = await this.companyService.count(where);

      return {
        items: companies,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading companies!');
    }
  }

  @Query(() => Company)
  async getCompany(@Args('id', { type: () => String }) id: string) {
    try {
      return this.companyService.getCompanyById(id);
    } catch (e) {
      throw new BadRequestException('Error loading company!');
    }
  }

  @Mutation(() => Company)
  async createCompany(
    @Args('createCompanyInput') createCompanyInput: CreateCompanyInput,
  ) {
    try {
      return this.companyService.createCompany(createCompanyInput);
    } catch (e) {
      throw new BadRequestException('Error creating company!');
    }
  }

  @Mutation(() => Company)
  async updateCompany(
    @Args('id') companyId: string,
    @Args('updateCompanyInput') updateCompanyInput: UpdateCompanyInput,
  ) {
    try {
      return this.companyService.updateCompany(companyId, updateCompanyInput);
    } catch (e) {
      throw new BadRequestException('Error updating company!');
    }
  }

  @Mutation(() => Company)
  async deleteCompany(@Args('id', { type: () => String }) id: string) {
    try {
      return this.companyService.deleteCompany(id);
    } catch (e) {
      throw new BadRequestException('Error deleting company!');
    }
  }
}
