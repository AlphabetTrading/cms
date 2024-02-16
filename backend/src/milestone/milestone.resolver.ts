import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { Milestone } from './model/milestone.model';
import { MilestoneService } from './milestone.service';
import { CreateMilestoneInput } from './dto/create-milestone.input';
import { UpdateMilestoneInput } from './dto/update-milestone.input';
import { BadRequestException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { FilterMilestoneInput } from './dto/filter-milestone.input';
import { OrderByMilestoneInput } from './dto/order-by-milestone.input';
import { PaginationMilestones } from 'src/common/pagination/pagination-info';

@Resolver('Milestone')
export class MilestoneResolver {
  constructor(private readonly milestoneService: MilestoneService) {}

  @Query(() => PaginationMilestones)
  async getMilestones(
    @Args('filterMilestoneInput', {
      type: () => FilterMilestoneInput,
      nullable: true,
    })
    filterMilestoneInput?: FilterMilestoneInput,
    @Args('orderBy', {
      type: () => OrderByMilestoneInput,
      nullable: true,
    })
    orderBy?: OrderByMilestoneInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
  ) {
    const where: Prisma.MilestoneWhereInput = {
      AND: [
        {
          id: filterMilestoneInput?.id,
        },
        {
          OR: [
            {
              name: filterMilestoneInput?.name,
            },
            {
              dueDate: filterMilestoneInput?.dueDate,
            },
            {
              projectId: filterMilestoneInput?.projectId,
            },
            {
              status: filterMilestoneInput?.status,
            },
          ],
        },
        {
          createdAt: filterMilestoneInput?.createdAt,
        },
      ],
    };

    try {
      const milestones = await this.milestoneService.findAll({
        where,
        orderBy,
        skip: paginationInput?.skip,
        take: paginationInput?.take,
      });

      const count = await this.milestoneService.count(where);

      return {
        items: milestones,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      throw new BadRequestException('Error loading milestones!');
    }
  }

  @Query(() => Milestone)
  async getMilestone(@Args('id', { type: () => String }) id: string) {
    try {
      return this.milestoneService.findOne(id);
    } catch (e) {
      throw new BadRequestException('Error loading milestone!');
    }
  }

  @Mutation(() => Milestone)
  async createMilestone(
    @Args('createMilestoneInput') createMilestoneInput: CreateMilestoneInput,
  ) {
    try {
      return this.milestoneService.create(createMilestoneInput);
    } catch (e) {
      throw new BadRequestException('Error creating milestone!');
    }
  }

  @Mutation(() => Milestone)
  async updateMilestone(
    @Args('id') milestoneId: string,
    @Args('updateMilestoneInput') updateMilestoneInput: UpdateMilestoneInput,
  ) {
    try {
      return this.milestoneService.update(milestoneId, updateMilestoneInput);
    } catch (e) {
      throw new BadRequestException('Error updating milestone!');
    }
  }

  @Mutation(() => Milestone)
  async deleteMilestone(@Args('id', { type: () => String }) id: string) {
    try {
      return this.milestoneService.remove(id);
    } catch (e) {
      throw new BadRequestException('Error deleting milestone!');
    }
  }
}
