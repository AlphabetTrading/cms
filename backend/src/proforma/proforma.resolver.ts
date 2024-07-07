import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { ProformaService } from './proforma.service';
import { CreateProformaInput } from './dto/create-proforma.input';
import { UpdateProformaInput } from './dto/update-proforma.input';
import { PaginationProformas } from 'src/common/pagination/pagination-info';
import { FilterProformaInput } from './dto/filter-proforma.input';
import { OrderByProformaInput } from './dto/order-by-proforma.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { ApprovalStatus, Prisma, User } from '@prisma/client';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { Proforma } from './model/proforma.model';
import { HasRoles, UserEntity } from 'src/common/decorators';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';
import * as GraphQLUpload from 'graphql-upload/GraphQLUpload.js';
import * as FileUpload from 'graphql-upload/Upload.js';
import { RolesGuard } from 'src/auth/guards/roles.guard';

@UseGuards(GqlAuthGuard, RolesGuard)
@Resolver(() => Proforma)
export class ProformaResolver {
  constructor(private readonly proformaService: ProformaService) {}

  @Query(() => PaginationProformas)
  async getProformas(
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
  ): Promise<PaginationProformas> {
    const where: Prisma.ProformaWhereInput = {
      AND: [
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
            {
              vendor: filterProformaInput?.vendor,
            },
            {
              remark: filterProformaInput?.remark,
            },
          ],
        },
        {
          createdAt: filterProformaInput?.createdAt,
        },
        {
          updatedAt: filterProformaInput?.updatedAt,
        },
      ],
    };

    try {
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
    @Args('photo', { type: () => GraphQLUpload, nullable: true }) photo?: FileUpload,
  ) {
    try {
      return await this.proformaService.createProforma(createProforma, photo);
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
    @Args('newPhoto', { type: () => GraphQLUpload, nullable: true }) newPhoto?: FileUpload,
  ) {
    try {
      return this.proformaService.updateProforma(updateProformaInput, newPhoto);
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
    @Args('decision', { type: () => ApprovalStatus })
    decision: ApprovalStatus,
  ) {
    try {
      return this.proformaService.approveProforma(
        proformaId,
        user.id,
        decision,
      );
    } catch (e) {
      console.log(e)
      throw new BadRequestException(
        e.message || 'Error approving proforma!',
      );
    }
  }

}
