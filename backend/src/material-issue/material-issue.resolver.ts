import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { MaterialIssueService } from './material-issue.service';
import { CreateMaterialIssueInput } from './dto/create-material-issue.input';
import { UpdateMaterialIssueInput } from './dto/update-material-issue.input';
import { MaterialIssueVoucher } from './model/material-issue.model';
import { FilterMaterialIssueInput } from './dto/filter-material-issue.input';
import { OrderByMaterialIssueInput } from './dto/order-by-material-issue.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { PaginationMaterialIssues } from 'src/common/pagination/pagination-info';
import { Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';

@Resolver('MaterialIssue')
export class MaterialIssueResolver {
  constructor(private readonly materialIssueService: MaterialIssueService) {}

  @Query(() => PaginationMaterialIssues)
  async getMaterialIssues(
    @Args('filterMaterialIssueInput', {
      type: () => FilterMaterialIssueInput,
      nullable: true,
    })
    filterMaterialIssueInput?: FilterMaterialIssueInput,
    @Args('orderBy', {
      type: () => OrderByMaterialIssueInput,
      nullable: true,
    })
    orderBy?: OrderByMaterialIssueInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ): Promise<PaginationMaterialIssues> {
    const where: Prisma.MaterialIssueVoucherWhereInput = {
      AND: [
        {
          id: filterMaterialIssueInput?.id,
        },
        {
          OR: [
            {
              issuedToId: filterMaterialIssueInput?.issuedToId,
            },
            {
              preparedById: filterMaterialIssueInput?.preparedById,
            },
            {
              approvedById: filterMaterialIssueInput?.approvedById,
            },
            {
              status: filterMaterialIssueInput?.status,
            },
          ],
        },
        {
          createdAt: filterMaterialIssueInput?.createdAt,
        },
      ],
    };

    try {
      const materialIssues = await this.materialIssueService.getMaterialIssues({
        where,
        orderBy,
        skip: paginationInput?.skip,
        take: paginationInput?.take,
      });

      const count = await this.materialIssueService.count(where);

      return {
        items: materialIssues,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading material issues!');
    }
  }

  @Query(() => MaterialIssueVoucher)
  async getMaterialIssueById(@Args('id') materialIssueId: string) {
    try {
      return this.materialIssueService.getMaterialIssueById(materialIssueId);
    } catch (e) {
      throw new BadRequestException('Error loading material issue!');
    }
  }

  @Mutation(() => MaterialIssueVoucher)
  async createMaterialIssue(
    @Args('createMaterialIssueInput')
    createMaterialIssue: CreateMaterialIssueInput,
  ) {
    try {
      return await this.materialIssueService.createMaterialIssue(
        createMaterialIssue,
      );
    } catch (e) {
      console.log(e)
      throw new BadRequestException('Error creating material issue!');
    }
  }

  @Mutation(() => MaterialIssueVoucher)
  async updateMaterialIssue(
    @Args('id') materialIssueId: string,
    @Args('updateMaterialIssueInput')
    updateMaterialIssueInput: UpdateMaterialIssueInput,
  ) {
    try {
      return this.materialIssueService.updateMaterialIssue(
        materialIssueId,
        updateMaterialIssueInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating material issue!');
    }
  }

  @Mutation(() => MaterialIssueVoucher)
  async deleteMaterialIssue(@Args('id') materialIssueId: string) {
    try {
      return this.materialIssueService.deleteMaterialIssue(materialIssueId);
    } catch (e) {
      throw new BadRequestException('Error deleting material issue!');
    }
  }
}
