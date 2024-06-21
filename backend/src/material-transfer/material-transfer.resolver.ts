import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { MaterialTransferService } from './material-transfer.service';
import { CreateMaterialTransferInput } from './dto/create-material-transfer.input';
import { UpdateMaterialTransferInput } from './dto/update-material-transfer.input';
import { MaterialTransferVoucher } from './model/material-transfer.model';
import { FilterMaterialTransferInput } from 'src/material-transfer/dto/filter-material-transfer.input';
import { OrderByMaterialTransferInput } from 'src/material-transfer/dto/order-by-material-transfer.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { PaginationMaterialTransfers } from 'src/common/pagination/pagination-info';
import { ApprovalStatus, Prisma, User } from '@prisma/client';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { UserEntity } from 'src/common/decorators';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';

@UseGuards(GqlAuthGuard)
@Resolver('MaterialTransfer')
export class MaterialTransferResolver {
  constructor(
    private readonly materialTransferService: MaterialTransferService,
  ) {}

  @Query(() => PaginationMaterialTransfers)
  async getMaterialTransfers(
    @UserEntity() user: User,
    @Args('filterMaterialTransferInput', {
      type: () => FilterMaterialTransferInput,
      nullable: true,
    })
    filterMaterialTransferInput?: FilterMaterialTransferInput,
    @Args('orderBy', {
      type: () => OrderByMaterialTransferInput,
      nullable: true,
    })
    orderBy?: OrderByMaterialTransferInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
    @Args('mine', { type: () => Boolean, defaultValue: false })
    mine?: boolean,
  ): Promise<PaginationMaterialTransfers> {
    try {
      const where: Prisma.MaterialTransferVoucherWhereInput = {
        AND: [
          {
            id: filterMaterialTransferInput?.id,
          },
          {
            projectId: filterMaterialTransferInput?.projectId,
          },
          ...(mine
            ? [
                {
                  OR: [
                    {
                      preparedById: user.id,
                    },
                    {
                      approvedById: user.id,
                    },
                  ],
                },
              ]
            : []),
          {
            OR: [
              {
                serialNumber: filterMaterialTransferInput?.serialNumber,
              },
              {
                receivingWarehouseStoreId:
                  filterMaterialTransferInput?.receivingWarehouseStoreId,
              },
              {
                receivingWarehouseStore:
                  filterMaterialTransferInput?.receivingWarehouseStore,
              },
              {
                sendingWarehouseStoreId:
                  filterMaterialTransferInput?.sendingWarehouseStoreId,
              },
              {
                sendingWarehouseStore:
                  filterMaterialTransferInput?.sendingWarehouseStore,
              },
              {
                preparedById: filterMaterialTransferInput?.preparedById,
              },
              {
                approvedById: filterMaterialTransferInput?.approvedById,
              },
              {
                preparedBy: filterMaterialTransferInput?.preparedBy,
              },
              {
                approvedBy: filterMaterialTransferInput?.approvedBy,
              },
              {
                status: {
                  in: filterMaterialTransferInput?.status,
                },
              },
            ],
          },
          {
            createdAt: filterMaterialTransferInput?.createdAt,
          },
        ],
      };

      const materialTransfers =
        await this.materialTransferService.getMaterialTransfers({
          where,
          orderBy,
          skip: paginationInput?.skip,
          take: paginationInput?.take,
        });

      const count = await this.materialTransferService.count(where);

      return {
        items: materialTransfers,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading material transfers!');
    }
  }

  @Query(() => MaterialTransferVoucher)
  async getMaterialTransferById(@Args('id') materialTransferId: string) {
    try {
      return this.materialTransferService.getMaterialTransferById(
        materialTransferId,
      );
    } catch (e) {
      throw new BadRequestException('Error loading material transfer!');
    }
  }

  @Mutation(() => MaterialTransferVoucher)
  async createMaterialTransfer(
    @Args('createMaterialTransferInput')
    createMaterialTransfer: CreateMaterialTransferInput,
  ) {
    try {
      return await this.materialTransferService.createMaterialTransfer(
        createMaterialTransfer,
      );
    } catch (e) {
      throw new BadRequestException('Error creating material transfer!');
    }
  }

  @Mutation(() => MaterialTransferVoucher)
  async updateMaterialTransfer(
    @Args('updateMaterialTransferInput')
    updateMaterialTransferInput: UpdateMaterialTransferInput,
  ) {
    try {
      return this.materialTransferService.updateMaterialTransfer(
        updateMaterialTransferInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating material transfer!');
    }
  }

  @Mutation(() => MaterialTransferVoucher)
  async deleteMaterialTransfer(@Args('id') materialTransferId: string) {
    try {
      return this.materialTransferService.deleteMaterialTransfer(
        materialTransferId,
      );
    } catch (e) {
      throw new BadRequestException('Error deleting material transfer!');
    }
  }

  @Mutation(() => MaterialTransferVoucher)
  async approveMaterialTransfer(
    @UserEntity() user: User,
    @Args('materialTransferId') materialTransferId: string,
    @Args('decision', { type: () => ApprovalStatus })
    decision: ApprovalStatus,
  ) {
    try {
      return this.materialTransferService.approveMaterialTransfer(
        materialTransferId,
        user.id,
        decision,
      );
    } catch (e) {
      throw new BadRequestException(e.message || 'Error approving material transfer!');
    }
  }

  @Query(() => String)
  async generateMaterialTransferPdf(@Args('id') id: string): Promise<string> {
    try {
      return await this.materialTransferService.generatePdf(id);
    } catch (e) {
      throw new BadRequestException(
        e.message || 'Error generating material Transfer pdf!',
      );
    }
  }
}
