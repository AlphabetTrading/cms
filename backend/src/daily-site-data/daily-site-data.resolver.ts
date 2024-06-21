import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { PaginationInput } from 'src/common/pagination/pagination.input';
import { ApprovalStatus, Prisma, User } from '@prisma/client';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { UserEntity } from 'src/common/decorators';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';
import { DailySiteDataService } from './daily-site-data.service';
import { PaginationDailySiteData } from 'src/common/pagination/pagination-info';
import { FilterDailySiteDataInput } from './dto/filter-daily-site-data.input';
import { OrderByDailySiteDataInput } from './dto/order-by-daily-site-data.input';
import { DailySiteData } from './model/daily-site-data.model';
import { CreateDailySiteDataInput } from './dto/create-daily-site-data.input';
import { UpdateDailySiteDataInput } from './dto/update-daily-site-data.input';

@UseGuards(GqlAuthGuard)
@Resolver('DailySiteData')
export class DailySiteDataResolver {
  constructor(private readonly dailySiteDataService: DailySiteDataService) {}

  @Query(() => PaginationDailySiteData)
  async getDailySiteDatas(
    @UserEntity() user: User,
    @Args('filterDailySiteDataInput', {
      type: () => FilterDailySiteDataInput,
      nullable: true,
    })
    filterDailySiteDataInput?: FilterDailySiteDataInput,
    @Args('orderBy', {
      type: () => OrderByDailySiteDataInput,
      nullable: true,
    })
    orderBy?: OrderByDailySiteDataInput,
    @Args('paginationInput', { type: () => PaginationInput, nullable: true })
    paginationInput?: PaginationInput,
    @Args('mine', { type: () => Boolean, defaultValue: false })
    mine?: boolean,
  ): Promise<PaginationDailySiteData> {
    let approverIds: string[] = [];

    const approvers =
      await this.dailySiteDataService.getDailySiteDataApprovers();
    approverIds = approvers.map((approver) => approver.ProjectManager.id);

    try {
      const baseConditions: Prisma.DailySiteDataWhereInput[] = [
        { id: filterDailySiteDataInput?.id },
        { projectId: filterDailySiteDataInput?.projectId },
        {
          OR: [
            { date: filterDailySiteDataInput?.date },
            { contractor: filterDailySiteDataInput?.contractor },
            { preparedById: filterDailySiteDataInput?.preparedById },
            { checkedById: filterDailySiteDataInput?.checkedById },
            { approvedById: filterDailySiteDataInput?.approvedById },
            { preparedBy: filterDailySiteDataInput?.preparedBy },
            { checkedBy: filterDailySiteDataInput?.checkedBy },
            { approvedBy: filterDailySiteDataInput?.approvedBy },
            {
              status: {
                in: filterDailySiteDataInput?.status,
              },
            },
          ],
        },
        { createdAt: filterDailySiteDataInput?.createdAt },
      ].filter(Boolean);

      if (mine) {
        baseConditions.push({
          OR: [
            { preparedById: user.id },
            { approvedById: user.id },
            ...(approverIds.includes(user.id)
              ? [
                  {
                    projectId: filterDailySiteDataInput?.projectId,
                  },
                ]
              : []),
          ],
        });
      }

      const where: Prisma.DailySiteDataWhereInput = {
        AND: baseConditions,
      };

      const dailySiteDatas = await this.dailySiteDataService.getDailySiteDatas({
        where,
        orderBy,
        skip: paginationInput?.skip,
        take: paginationInput?.take,
      });

      const count = await this.dailySiteDataService.count(where);

      return {
        items: dailySiteDatas,
        meta: {
          page: paginationInput?.skip,
          limit: paginationInput?.take,
          count: count,
        },
      };
    } catch (e) {
      console.log(e);
      throw new BadRequestException('Error loading daily site datas!');
    }
  }

  @Query(() => DailySiteData)
  async getDailySiteDataById(@Args('id') dailySiteDataId: string) {
    try {
      return this.dailySiteDataService.getDailySiteDataById(dailySiteDataId);
    } catch (e) {
      throw new BadRequestException('Error loading daily site data!');
    }
  }

  @Mutation(() => DailySiteData)
  async createDailySiteData(
    @Args('createDailySiteDataInput')
    createDailySiteData: CreateDailySiteDataInput,
  ) {
    try {
      return await this.dailySiteDataService.createDailySiteData(
        createDailySiteData,
      );
    } catch (e) {
      throw new BadRequestException('Error creating daily site data!');
    }
  }

  @Mutation(() => DailySiteData)
  async updateDailySiteData(
    @Args('updateDailySiteDataInput')
    updateDailySiteDataInput: UpdateDailySiteDataInput,
  ) {
    try {
      return this.dailySiteDataService.updateDailySiteData(
        updateDailySiteDataInput,
      );
    } catch (e) {
      throw new BadRequestException('Error updating daily site data!');
    }
  }

  @Mutation(() => DailySiteData)
  async deleteDailySiteData(@Args('id') dailySiteDataId: string) {
    try {
      return this.dailySiteDataService.deleteDailySiteData(dailySiteDataId);
    } catch (e) {
      throw new BadRequestException('Error deleting daily site data!');
    }
  }

  @Mutation(() => DailySiteData)
  async approveDailySiteData(
    @UserEntity() user: User,
    @Args('dailySiteDataId') dailySiteDataId: string,
    @Args('decision', { type: () => ApprovalStatus })
    decision: ApprovalStatus,
  ): Promise<DailySiteData> {
    try {
      return await this.dailySiteDataService.approveDailySiteData(
        dailySiteDataId,
        user.id,
        decision,
      );
    } catch (e) {
      throw new BadRequestException(
        e.message || 'Error approving daily site data!',
      );
    }
  }

  @Query(() => String)
  async generateDailySiteDataPdf(@Args('id') id: string): Promise<string> {
    try {
      return await this.dailySiteDataService.generatePdf(id);
    } catch (e) {
      throw new BadRequestException(
        e.message || 'Error generating daily site data pdf!',
      );
    }
  }
}
