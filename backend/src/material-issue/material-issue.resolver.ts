import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { MaterialIssueService } from './material-issue.service';
import { CreateMaterialIssueInput } from './dto/create-material-issue.input';
import { UpdateMaterialIssueInput } from './dto/update-material-issue.input';
import { MaterialIssueVoucher } from './model/material-issue.model';
import { FilterMaterialIssueInput } from './dto/filter-material-issue.input';
import { OrderByMaterialIssueInput } from './dto/order-by-material-issue.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { PaginationMaterialIssues } from 'src/common/pagination/pagination-info';
import { ApprovalStatus, Prisma, User } from '@prisma/client';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { UserEntity } from 'src/common/decorators';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';

@UseGuards(GqlAuthGuard)
@Resolver('MaterialIssue')
export class MaterialIssueResolver {
  constructor(private readonly materialIssueService: MaterialIssueService) {}

  @Query(() => PaginationMaterialIssues)
  async getMaterialIssues(
    @UserEntity() user: User,
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
    @Args('mine', { type: () => Boolean, defaultValue: false })
    mine?: boolean,
  ): Promise<PaginationMaterialIssues> {
    let approverIds: string[] = [];

    if (filterMaterialIssueInput?.projectId) {
      const approvers =
        await this.materialIssueService.getMaterialIssueApprovers(
          filterMaterialIssueInput?.projectId,
        );
      approverIds = approvers.map((approver) => approver.storeManagerId);
    }

    try {
      const baseConditions: Prisma.MaterialIssueVoucherWhereInput[] = [
        { id: filterMaterialIssueInput?.id },
        { projectId: filterMaterialIssueInput?.projectId },
        {
          OR: [
            { serialNumber: filterMaterialIssueInput?.serialNumber },
            { warehouseStoreId: filterMaterialIssueInput?.warehouseStoreId },
            { warehouseStore: filterMaterialIssueInput?.warehouseStore },
            { preparedById: filterMaterialIssueInput?.preparedById },
            { approvedById: filterMaterialIssueInput?.approvedById },
            { preparedBy: filterMaterialIssueInput?.preparedBy },
            { approvedBy: filterMaterialIssueInput?.approvedBy },
            {
              status: {
                in: filterMaterialIssueInput?.status,
              },
            },
          ],
        },
        { createdAt: filterMaterialIssueInput?.createdAt },
      ].filter(Boolean);

      if (mine) {
        baseConditions.push({
          OR: [
            { preparedById: user.id },
            { approvedById: user.id },
            ...(approverIds.includes(user.id)
              ? [
                  {
                    projectId: filterMaterialIssueInput?.projectId,
                  },
                ]
              : []),
          ],
        });
      }

      const where: Prisma.MaterialIssueVoucherWhereInput = {
        AND: baseConditions,
      };

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
      console.log(e);
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
      throw new BadRequestException('Error creating material issue!');
    }
  }

  @Mutation(() => MaterialIssueVoucher)
  async updateMaterialIssue(
    @Args('updateMaterialIssueInput')
    updateMaterialIssueInput: UpdateMaterialIssueInput,
  ) {
    try {
      return this.materialIssueService.updateMaterialIssue(
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

  @Mutation(() => MaterialIssueVoucher)
  async approveMaterialIssue(
    @UserEntity() user: User,
    @Args('materialIssueId') materialIssueId: string,
    @Args('decision', { type: () => ApprovalStatus })
    decision: ApprovalStatus,
  ): Promise<MaterialIssueVoucher> {
    try {
      return await this.materialIssueService.approveMaterialIssue(
        materialIssueId,
        user.id,
        decision,
      );
    } catch (e) {
      throw new BadRequestException(
        e.message || 'Error approving material issue!',
      );
    }
  }

  @Query(() => String)
  async generateMaterialIssuePdf(@Args('id') id: string): Promise<string> {
    try {
      return await this.materialIssueService.generatePdf(id);
    } catch (e) {
      throw new BadRequestException(
        e.message || 'Error generating material issue pdf!',
      );
    }
  }
}
