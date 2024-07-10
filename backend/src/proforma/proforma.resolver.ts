import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { ProformaService } from './proforma.service';
import { CreateProformaInput } from './dto/create-proforma.input';
import { UpdateProformaInput } from './dto/update-proforma.input';
import { PaginationProformas } from 'src/common/pagination/pagination-info';
import { FilterProformaInput } from './dto/filter-proforma.input';
import { OrderByProformaInput } from './dto/order-by-proforma.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { Prisma, User } from '@prisma/client';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { Proforma } from './model/proforma.model';
import { HasRoles, UserEntity } from 'src/common/decorators';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';
import { RolesGuard } from 'src/auth/guards/roles.guard';

@UseGuards(GqlAuthGuard, RolesGuard)
@Resolver(() => Proforma)
export class ProformaResolver {
  constructor(private readonly proformaService: ProformaService) {}

  @Query(() => PaginationProformas)
  async getProformas(
    @UserEntity() user: User,
    @Args('filterProformaInput', {
      type: () => FilterProformaInput,
      nullable: true,
    })
    filterProformaInput?: FilterProformaInput,
    @Args('orderBy', {
      type: () => OrderByProformaInput,
      nullable: true,
    })
    orderBy?: OrderByProformaInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
    @Args('mine', { type: () => Boolean, defaultValue: false })
    mine?: boolean,
  ): Promise<PaginationProformas> {
    let approverIds: string[] = [];

    if (filterProformaInput?.projectId) {
      const approvers =
        await this.proformaService.getProformaApprovers(
          filterProformaInput.projectId,
        );
      approverIds = approvers.flatMap((approver) =>
        approver.ProjectUsers.map((projectUser) => projectUser.userId),
      );
    }

    try {
      const baseConditions: Prisma.ProformaWhereInput[] = [
        {
          id: filterProformaInput?.id,
        },
        {
          projectId: filterProformaInput?.projectId,
        },
        {
          OR: [
            {
              materialRequestItemId: filterProformaInput?.materialRequestItemId,
            },
          ],
        },
        {
          createdAt: filterProformaInput?.createdAt,
        },
        {
          updatedAt: filterProformaInput?.updatedAt,
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
                    projectId: filterProformaInput?.projectId,
                  },
                ]
              : []),
          ],
        });
      }

      const where: Prisma.ProformaWhereInput = {
        AND: baseConditions,
      };

      const proformas = await this.proformaService.getProformas({
        where,
        orderBy,
        skip: paginationInput?.skip,
        take: paginationInput?.take,
      });

      const count = await this.proformaService.count(where);

      return {
        items: proformas,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading proformas!');
    }
  }

  @Query(() => Proforma)
  async getProformaById(@Args('id') proformaId: string) {
    try {
      return this.proformaService.getProformaById(proformaId);
    } catch (e) {
      throw new BadRequestException('Error loading proforma!');
    }
  }

  @Mutation(() => Proforma)
  @HasRoles('PURCHASER')
  async createProforma(
    @Args('createProformaInput')
    createProforma: CreateProformaInput,
  ) {
    try {
      return await this.proformaService.createProforma(createProforma);
    } catch (e) {
      console.log(e);
      throw new BadRequestException('Error creating proforma!');
    }
  }

  @Mutation(() => Proforma)
  @HasRoles('PURCHASER')
  async updateProforma(
    @Args('updateProformaInput')
    updateProformaInput: UpdateProformaInput,
  ) {
    try {
      return this.proformaService.updateProforma(updateProformaInput);
    } catch (e) {
      console.log(e);
      throw new BadRequestException('Error updating proforma!');
    }
  }

  @Mutation(() => Proforma)
  @HasRoles('PURCHASER')
  async deleteProforma(@Args('id') proformaId: string) {
    try {
      return this.proformaService.deleteProforma(proformaId);
    } catch (e) {
      throw new BadRequestException('Error deleting proforma!');
    }
  }

  @Mutation(() => Proforma)
  @HasRoles('PROJECT_MANAGER')
  async approveProforma(
    @UserEntity() user: User,
    @Args('proformaId') proformaId: string,
    @Args('selectedProformaItemId') selectedProformaItemId: string,
  ) {
    try {
      return this.proformaService.approveProforma(
        proformaId,
        user.id,
        selectedProformaItemId
      );
    } catch (e) {
      console.log(e)
      throw new BadRequestException(
        e.message || 'Error approving proforma!',
      );
    }
  }

}
