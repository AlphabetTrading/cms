import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { MaterialReturnService } from './material-return.service';
import { MaterialReturnVoucher } from './model/material-return.model';
import { CreateMaterialReturnInput } from './dto/create-material-return.input';
import { UpdateMaterialReturnInput } from './dto/update-material-return.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { FilterMaterialReturnInput } from './dto/filter-material-return.input';
import { OrderByMaterialReturnInput } from './dto/order-by-material-return.input';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { ApprovalStatus, Prisma, User } from '@prisma/client';
import { PaginationMaterialReturns } from 'src/common/pagination/pagination-info';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';
import { HasRoles, UserEntity } from 'src/common/decorators';
import { RolesGuard } from 'src/auth/guards/roles.guard';


@UseGuards(GqlAuthGuard, RolesGuard)
@Resolver('MaterialReturn')
export class MaterialReturnResolver {
  constructor(private readonly materialReturnService: MaterialReturnService) {}

  @UseGuards(GqlAuthGuard)
  @Query(() => PaginationMaterialReturns)
  async getMaterialReturns(
    @UserEntity() user: User,
    @Args('filterMaterialReturnInput', {
      type: () => FilterMaterialReturnInput,
      nullable: true,
    })
    filterMaterialReturnInput?: FilterMaterialReturnInput,
    @Args('orderBy', {
      type: () => OrderByMaterialReturnInput,
      nullable: true,
    })
    orderBy?: OrderByMaterialReturnInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
    @Args('mine', { type: () => Boolean, defaultValue: false })
    mine?: boolean,
  ) {
    let approverIds: string[] = [];

    if (filterMaterialReturnInput.projectId) {
      const approvers =
        await this.materialReturnService.getMaterialReturnApprovers(
          filterMaterialReturnInput.projectId,
        );
      approverIds = approvers.map((approver) => approver.storeManagerId);
    }

    try {
      const baseConditions: Prisma.MaterialReturnVoucherWhereInput[] = [
        {
          id: filterMaterialReturnInput?.id,
        },
        {
          projectId: filterMaterialReturnInput?.projectId,
        },
        {
          OR: [
            {
              serialNumber: filterMaterialReturnInput?.serialNumber,
            },
            {
              receivingWarehouseStoreId:
                filterMaterialReturnInput?.receivingWarehouseStoreId,
            },
            {
              receivingWarehouseStore:
                filterMaterialReturnInput?.receivingWarehouseStore,
            },
            {
              receivedById: filterMaterialReturnInput?.receivedById || user.id,
            },
            {
              receivedBy: filterMaterialReturnInput?.receivedBy,
            },
            {
              returnedById: filterMaterialReturnInput?.returnedById || user.id,
            },
            {
              returnedBy: filterMaterialReturnInput?.returnedBy,
            },
            {
              status: {
                in: filterMaterialReturnInput?.status,
              },
            },
          ],
        },
        {
          createdAt: filterMaterialReturnInput?.createdAt,
        },
      ].filter(Boolean);

      if (mine) {
        baseConditions.push({
          OR: [
            { returnedById: user.id },
            { receivedById: user.id },
            ...(approverIds.includes(user.id)
              ? [
                  {
                    projectId: filterMaterialReturnInput?.projectId,
                  },
                ]
              : []),
          ],
        });
      }

      const where: Prisma.MaterialReturnVoucherWhereInput = {
        AND: baseConditions,
      };

      const materialReturns =
        await this.materialReturnService.getMaterialReturns({
          where,
          orderBy,
          skip: paginationInput?.skip,
          take: paginationInput?.take,
        });

      const count = await this.materialReturnService.count(where);

      return {
        items: materialReturns,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading material returns!');
    }
  }

  @Query(() => MaterialReturnVoucher)
  async getMaterialReturnById(@Args('id') materialReturnId: string) {
    try {
      return this.materialReturnService.getMaterialReturnById(materialReturnId);
    } catch (e) {
      throw new BadRequestException('Error loading material return!');
    }
  }

  @Mutation(() => MaterialReturnVoucher)
  @HasRoles('SITE_MANAGER')
  async createMaterialReturn(
    @Args('createMaterialReturnInput')
    createMaterialReturn: CreateMaterialReturnInput,
  ) {
    try {
      return await this.materialReturnService.createMaterialReturn(
        createMaterialReturn,
      );
    } catch (e) {
      throw new BadRequestException('Error creating material return!');
    }
  }

  @Mutation(() => MaterialReturnVoucher)
  @HasRoles('SITE_MANAGER')
  async updateMaterialReturn(
    @Args('updateMaterialReturnInput')
    updateMaterialReturnInput: UpdateMaterialReturnInput,
  ) {
    try {
      return this.materialReturnService.updateMaterialReturn(
        updateMaterialReturnInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating material return!');
    }
  }

  @Mutation(() => MaterialReturnVoucher)
  @HasRoles('SITE_MANAGER')
  async deleteMaterialReturn(@Args('id') materialReturnId: string) {
    try {
      return this.materialReturnService.deleteMaterialReturn(materialReturnId);
    } catch (e) {
      throw new BadRequestException('Error deleting material return!');
    }
  }

  @Mutation(() => MaterialReturnVoucher)
  @HasRoles('STORE_MANAGER')
  async approveMaterialReturn(
    @UserEntity() user: User,
    @Args('materialReturnId') materialReturnId: string,
    @Args('decision', { type: () => ApprovalStatus })
    decision: ApprovalStatus,
  ) {
    try {
      return this.materialReturnService.approveMaterialReturn(
        materialReturnId,
        user.id,
        decision,
      );
    } catch (e) {
      throw new BadRequestException(
        e.message || 'Error approving material return!',
      );
    }
  }

  @Query(() => String)
  async generateMaterialReturnPdf(@Args('id') id: string): Promise<string> {
    try {
      return await this.materialReturnService.generatePdf(id);
    } catch (e) {
      throw new BadRequestException(
        e.message || 'Error generating material return pdf!',
      );
    }
  }
}
