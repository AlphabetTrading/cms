import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { Milestone } from './model/milestone.model';
import { MilestoneService } from './milestone.service';
import { CreateMilestoneInput } from './dto/create-milestone.input';
import { UpdateMilestoneInput } from './dto/update-milestone.input';

@Resolver('Milestone')
export class MilestoneResolver {
  constructor(private readonly milestoneService: MilestoneService) {}

  @Query(() => [Milestone])
  async getMilestones() {
    return this.milestoneService.findAll();
  }

  @Query(() => Milestone)
  async getMilestone(@Args('id', { type: () => String }) id: string) {
    return this.milestoneService.findOne(id);
  }

  @Mutation(() => Milestone)
  async createMilestone(
    @Args('createMilestoneInput') createMilestoneInput: CreateMilestoneInput,
  ) {
    return this.milestoneService.create(createMilestoneInput);
  }

  @Mutation(() => Milestone)
  async updateMilestone(
    @Args('id') milestoneId: string,
    @Args('updateMilestoneInput') updateMilestoneInput: UpdateMilestoneInput,
  ) {
    return this.milestoneService.update(milestoneId, updateMilestoneInput);
  }

  @Mutation(() => Milestone)
  async deleteMilestone(@Args('id', { type: () => String }) id: string) {
    return this.milestoneService.remove(id);
  }
}
