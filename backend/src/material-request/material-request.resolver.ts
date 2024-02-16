import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { MaterialRequestService } from './material-request.service';
import { MaterialRequestVoucher } from './model/material-request.model';
import { CreateMaterialRequestInput } from './dto/create-material-request.input';
import { UpdateMaterialRequestInput } from './dto/update-material-request.input';
import { FilterMaterialRequestInput } from './dto/filter-material-request.input';
import { OrderByMaterialRequestInput } from './dto/order-by-material-request.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';
import { PaginationMaterialRequests } from 'src/common/pagination/pagination-info';

@Resolver('MaterialRequest')
export class MaterialRequestResolver {
  constructor(
    private readonly materialRequestService: MaterialRequestService,
  ) {}

  @Query(() => PaginationMaterialRequests)
  async getMaterialRequests(
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
  ) {
    const where: Prisma.MaterialRequestVoucherWhereInput = {
      AND: [
        {
          id: filterMaterialRequestInput?.id,
        },
        {
          OR: [
            {
              date: filterMaterialRequestInput?.date,
            },
            {
              from: filterMaterialRequestInput?.from,
            },
            {
              to: filterMaterialRequestInput?.to,
            },
            {
              requestedById: filterMaterialRequestInput?.requestedById,
            },
            {
              approvedById: filterMaterialRequestInput?.approvedById,
            },
            {
              approved: filterMaterialRequestInput?.approved,
            },
          ],
        },
        {
          createdAt: filterMaterialRequestInput?.createdAt,
        },
      ],
    };

    try {
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
    @Args('id') materialRequestId: string,
    @Args('updateMaterialRequestInput')
    updateMaterialRequestInput: UpdateMaterialRequestInput,
  ) {
    try {
      return this.materialRequestService.updateMaterialRequest(
        materialRequestId,
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
}