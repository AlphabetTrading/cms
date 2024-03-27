import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { ProformaService } from './proforma.service';
import { CreateProformaInput } from './dto/create-proforma.input';
import { UpdateProformaInput } from './dto/update-proforma.input';
import { PaginationProformas } from 'src/common/pagination/pagination-info';
import { FilterProformaInput } from './dto/filter-proforma.input';
import { OrderByProformaInput } from './dto/order-by-proforma.input';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';
import { Proforma } from './model/proforma.model';

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
          OR: [
            {
              materialRequestId: filterProformaInput?.materialRequestId,
            },
            {
              vendor: filterProformaInput?.vendor,
            },
            {
              description: filterProformaInput?.description,
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
  async createProforma(
    @Args('createProformaInput')
    createProforma: CreateProformaInput,
  ) {
    try {
      return await this.proformaService.createProforma(createProforma);
    } catch (e) {
      throw new BadRequestException('Error creating proforma!');
    }
  }

  @Mutation(() => Proforma)
  async updateProforma(
    @Args('id') proformaId: string,
    @Args('updateProformaInput')
    updateProformaInput: UpdateProformaInput,
  ) {
    try {
      return this.proformaService.updateProforma(
        proformaId,
        updateProformaInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating proforma!');
    }
  }

  @Mutation(() => Proforma)
  async deleteProforma(@Args('id') proformaId: string) {
    try {
      return this.proformaService.deleteProforma(proformaId);
    } catch (e) {
      throw new BadRequestException('Error deleting proforma!');
    }
  }
}
