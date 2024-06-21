import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { MaterialRequestService } from './material-request.service';
import { MaterialRequestVoucher } from './model/material-request.model';
import { CreateMaterialRequestInput } from './dto/create-material-request.input';
import { UpdateMaterialRequestInput } from './dto/update-material-request.input';
import { FilterMaterialRequestInput } from './dto/filter-material-request.input';
import { OrderByMaterialRequestInput } from './dto/order-by-material-request.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { ApprovalStatus, Prisma, User } from '@prisma/client';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { PaginationMaterialRequests } from 'src/common/pagination/pagination-info';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';
import { UserEntity } from 'src/common/decorators';

@Resolver('MaterialRequest')
export class MaterialRequestResolver {
  constructor(
    private readonly materialRequestService: MaterialRequestService,
  ) {}

  @UseGuards(GqlAuthGuard)
  @Query(() => PaginationMaterialRequests)
  async getMaterialRequests(
    @UserEntity() user: User,
    @Args('filterMaterialRequestInput', {
      type: () => FilterMaterialRequestInput,
      nullable: true,
    })
    filterMaterialRequestInput?: FilterMaterialRequestInput,
    @Args('orderBy', {
      type: () => OrderByMaterialRequestInput,
      nullable: true,
    })
    orderBy?: OrderByMaterialRequestInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
    @Args('mine', { type: () => Boolean, defaultValue: false })
    mine?: boolean,
  ) {
    let approverIds: string[] = [];

    if (filterMaterialRequestInput?.projectId) {
      const approvers =
        await this.materialRequestService.getMaterialRequestApprovers(
          filterMaterialRequestInput.projectId,
        );
      approverIds = approvers.map((approver) => approver.ProjectManager.id);
    }

    try {
      const baseConditions: Prisma.MaterialRequestVoucherWhereInput[] = [
        {
          id: filterMaterialRequestInput?.id,
        },
        {
          projectId: filterMaterialRequestInput?.projectId,
        },
        {
          OR: [
            {
              serialNumber: filterMaterialRequestInput?.serialNumber,
            },
            {
              requestedById: filterMaterialRequestInput?.requestedById,
            },
            {
              requestedBy: filterMaterialRequestInput?.requestedBy,
            },
            {
              approvedById: filterMaterialRequestInput?.approvedById,
            },
            {
              approvedBy: filterMaterialRequestInput?.approvedBy,
            },
            {
              status: {
                in: filterMaterialRequestInput?.status,
              },
            },
          ],
        },
        {
          createdAt: filterMaterialRequestInput?.createdAt,
        },
      ].filter(Boolean);

      if (mine) {
        baseConditions.push({
          OR: [
            { requestedById: user.id },
            { approvedById: user.id },
            ...(approverIds.includes(user.id)
              ? [
                  {
                    projectId: filterMaterialRequestInput?.projectId,
                  },
                ]
              : []),
          ],
        });
      }

      const where: Prisma.MaterialRequestVoucherWhereInput = {
        AND: baseConditions,
      };

      const materialRequests =
        await this.materialRequestService.getMaterialRequests({
          where,
          orderBy,
          skip: paginationInput?.skip,
          take: paginationInput?.take,
        });
      const count = await this.materialRequestService.count(where);

      return {
        items: materialRequests,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading material requests!');
    }
  }

  @Query(() => MaterialRequestVoucher)
  async getMaterialRequestById(@Args('id') materialRequestId: string) {
    try {
      return this.materialRequestService.getMaterialRequestById(
        materialRequestId,
      );
    } catch (e) {
      throw new BadRequestException('Error loading material request!');
    }
  }

  @Mutation(() => MaterialRequestVoucher)
  async createMaterialRequest(
    @Args('createMaterialRequestInput')
    createMaterialRequest: CreateMaterialRequestInput,
  ) {
    try {
      return await this.materialRequestService.createMaterialRequest(
        createMaterialRequest,
      );
    } catch (e) {
      throw new BadRequestException('Error creating material request!');
    }
  }

  @Mutation(() => MaterialRequestVoucher)
  async updateMaterialRequest(
    @Args('updateMaterialRequestInput')
    updateMaterialRequestInput: UpdateMaterialRequestInput,
  ) {
    try {
      return this.materialRequestService.updateMaterialRequest(
        updateMaterialRequestInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating material request!');
    }
  }

  @Mutation(() => MaterialRequestVoucher)
  async deleteMaterialRequest(@Args('id') materialRequestId: string) {
    try {
      return this.materialRequestService.deleteMaterialRequest(
        materialRequestId,
      );
    } catch (e) {
      throw new BadRequestException('Error deleting material request!');
    }
  }

  @Mutation(() => MaterialRequestVoucher)
  async approveMaterialRequest(
    @UserEntity() user: User,
    @Args('materialRequestId') materialRequestId: string,
    @Args('decision', { type: () => ApprovalStatus })
    decision: ApprovalStatus,
  ) {
    try {
      return this.materialRequestService.approveMaterialRequest(
        materialRequestId,
        user.id,
        decision,
      );
    } catch (e) {
      throw new BadRequestException(e.message || 'Error approving material request!');
    }
  }

  @Query(() => String)
  async generateMaterialRequestPdf(@Args('id') id: string): Promise<string> {
    try {
      return await this.materialRequestService.generatePdf(id);
    } catch (e) {
      throw new BadRequestException(
        e.message || 'Error generating material request pdf!',
      );
    }
  }
}
