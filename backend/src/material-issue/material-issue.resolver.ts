import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { MaterialIssueService } from './material-issue.service';
import { CreateMaterialIssueInput } from './dto/create-material-issue.input';
import { UpdateMaterialIssueInput } from './dto/update-material-issue.input';
import { MaterialIssueVoucher } from './model/material-issue.model';

@Resolver('MaterialIssue')
export class MaterialIssueResolver {
  constructor(private readonly materialIssueService: MaterialIssueService) {}

  @Query(() => [MaterialIssueVoucher])
  async getMaterialIssues() {
    return this.materialIssueService.getMaterialIssues();
  }

  @Query(() => MaterialIssueVoucher)
  async getMaterialIssueById(@Args('id') materialIssueId: string) {
    return this.materialIssueService.getMaterialIssueById(materialIssueId);
  }

  @Mutation(() => MaterialIssueVoucher)
  async createMaterialIssue(
    @Args('createMaterialIssueInput')
    createMaterialIssue: CreateMaterialIssueInput,
  ) {
    try {
      return await this.materialIssueService.createMaterialIssue(
        createMaterialIssue,
      );
    } catch (e) {
      console.log(e);
      return e;
    }
  }

  @Mutation(() => MaterialIssueVoucher)
  async updateMaterialIssue(
    @Args('id') materialIssueId: string,
    @Args('updateMaterialIssueInput')
    updateMaterialIssueInput: UpdateMaterialIssueInput,
  ) {
    return this.materialIssueService.updateMaterialIssue(
      materialIssueId,
      updateMaterialIssueInput,
    );
  }

  @Mutation(() => MaterialIssueVoucher)
  async deleteMaterialIssue(@Args('id') materialIssueId: string) {
    return this.materialIssueService.deleteMaterialIssue(materialIssueId);
  }
}
