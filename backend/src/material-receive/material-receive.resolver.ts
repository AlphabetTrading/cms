import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { MaterialReceiveService } from './material-receive.service';
import { MaterialReceiveVoucher } from './model/material-receive.model';
import { CreateMaterialReceiveInput } from './dto/create-material-receive.input';
import { UpdateMaterialReceiveInput } from './dto/update-material-receive.input';
import { FilterMaterialReceiveInput } from './dto/filter-material-receive.input';
import { OrderByMaterialReceiveInput } from './dto/order-by-material-receive.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { PaginationMaterialReceives } from 'src/common/pagination/pagination-info';
import { ApprovalStatus, Prisma, User } from '@prisma/client';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';
import { HasRoles, UserEntity } from 'src/common/decorators';
// import { RolesGuard } from 'src/auth/guards/roles.guard';

@UseGuards(GqlAuthGuard)
//@UseGuards(GqlAuthGuard, RolesGuard)
@Resolver('MaterialReceive')
export class MaterialReceiveResolver {
  constructor(
    private readonly materialReceiveService: MaterialReceiveService,
  ) {}

  @Query(() => PaginationMaterialReceives)
  async getMaterialReceives(
    @UserEntity() user: User,
    @Args('filterMaterialReceiveInput', {
      type: () => FilterMaterialReceiveInput,
      nullable: true,
    })
    filterMaterialReceiveInput?: FilterMaterialReceiveInput,
    @Args('orderBy', {
      type: () => OrderByMaterialReceiveInput,
      nullable: true,
    })
    orderBy?: OrderByMaterialReceiveInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
    @Args('mine', { type: () => Boolean, defaultValue: false })
    mine?: boolean,
  ): Promise<PaginationMaterialReceives> {
    let approverIds: string[] = [];

    if (filterMaterialReceiveInput?.projectId) {
      const approvers =
        await this.materialReceiveService.getMaterialReceiveApprovers(
          filterMaterialReceiveInput.projectId,
        );
      approverIds = approvers.flatMap((approver) =>
        approver.ProjectUsers.map((projectUser) => projectUser.userId),
      );
    }

    try {
      const baseConditions: Prisma.MaterialReceiveVoucherWhereInput[] = [
        {
          id: filterMaterialReceiveInput?.id,
        },
        {
          projectId: filterMaterialReceiveInput?.projectId,
        },
        {
          OR: [
            {
              serialNumber: filterMaterialReceiveInput?.serialNumber,
            },
            {
              preparedById: filterMaterialReceiveInput?.preparedById,
            },
            {
              preparedBy: filterMaterialReceiveInput?.preparedBy,
            },
            {
              approvedById: filterMaterialReceiveInput?.approvedById,
            },
            {
              approvedBy: filterMaterialReceiveInput?.approvedBy,
            },
            {
              status: {
                in: filterMaterialReceiveInput?.status,
              },
            },
          ],
        },
        {
          createdAt: filterMaterialReceiveInput?.createdAt,
        },
      ].filter(Boolean);

      if (mine) {
        baseConditions.push({
          OR: [
            { preparedById: user.id },
            { approvedById: user.id },
            ...(approverIds.includes(user.id)
              ? [
                  {
                    projectId: filterMaterialReceiveInput?.projectId,
                  },
                ]
              : []),
          ],
        });
      }

      const where: Prisma.MaterialReceiveVoucherWhereInput = {
        AND: baseConditions,
      };

      const materialReceives =
        await this.materialReceiveService.getMaterialReceives({
          where,
          orderBy,
          skip: paginationInput?.skip,
          take: paginationInput?.take,
        });

      const count = await this.materialReceiveService.count(where);
      return {
        items: materialReceives,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading material receives!');
    }
  }

  @Query(() => MaterialReceiveVoucher)
  async getMaterialReceiveById(@Args('id') materialReceiveId: string) {
    try {
      return this.materialReceiveService.getMaterialReceiveById(
        materialReceiveId,
      );
    } catch (e) {
      throw new BadRequestException('Error loading material receive!');
    }
  }

  @Mutation(() => MaterialReceiveVoucher)
  @HasRoles('PURCHASER')
  async createMaterialReceive(
    @Args('createMaterialReceiveInput')
    createMaterialReceive: CreateMaterialReceiveInput,
  ) {
    try {
      return await this.materialReceiveService.createMaterialReceive(
        createMaterialReceive,
      );
    } catch (e) {
      throw new BadRequestException('Error creating material receive!');
    }
  }

  @Mutation(() => MaterialReceiveVoucher)
  @HasRoles('PURCHASER')
  async updateMaterialReceive(
    @Args('updateMaterialReceiveInput')
    updateMaterialReceiveInput: UpdateMaterialReceiveInput,
  ) {
    try {
      return this.materialReceiveService.updateMaterialReceive(
        updateMaterialReceiveInput,
      );
    } catch (e) {
      throw new BadRequestException(
        e.message || 'Error updating material receive!',
      );
    }
  }

  @Mutation(() => MaterialReceiveVoucher)
  @HasRoles('PROJECT_MANAGER')
  async approveMaterialReceive(
    @UserEntity() user: User,
    @Args('materialReceiveId') materialReceiveId: string,
    @Args('decision', { type: () => ApprovalStatus })
    decision: ApprovalStatus,
  ): Promise<MaterialReceiveVoucher> {
    try {
      return await this.materialReceiveService.approveMaterialReceive(
        materialReceiveId,
        user.id,
        decision,
      );
    } catch (e) {
      throw new BadRequestException('Error approving material request!');
    }
  }

  @Mutation(() => MaterialReceiveVoucher)
  @HasRoles('PURCHASER')
  async deleteMaterialReceive(@Args('id') materialReceiveId: string) {
    try {
      return await this.materialReceiveService.deleteMaterialReceive(
        materialReceiveId,
      );
    } catch (e) {
      throw new BadRequestException('Error deleting material receive!');
    }
  }

  @Query(() => String)
  async generateMaterialReceivePdf(@Args('id') id: string): Promise<string> {
    try {
      return await this.materialReceiveService.generatePdf(id);
    } catch (e) {
      throw new BadRequestException(
        e.message || 'Error generating material receive pdf!',
      );
    }
  }
}
