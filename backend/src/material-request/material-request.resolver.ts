import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { MaterialRequestService } from './material-request.service';
import { MaterialRequestVoucher } from './model/material-request.model';
import { CreateMaterialRequestInput } from './dto/create-material-request.input';
import { UpdateMaterialRequestInput } from './dto/update-material-request.input';

@Resolver('MaterialRequest')
export class MaterialRequestResolver {
  constructor(
    private readonly materialRequestService: MaterialRequestService,
  ) {}

  @Query(() => [MaterialRequestVoucher])
  async getMaterialRequests() {
    return this.materialRequestService.getMaterialRequests();
  }

  @Query(() => MaterialRequestVoucher)
  async getMaterialRequestById(@Args('id') materialRequestId: string) {
    return this.materialRequestService.getMaterialRequestById(
      materialRequestId,
    );
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
      console.log(e);
      return e;
    }
  }

  @Mutation(() => MaterialRequestVoucher)
  async updateMaterialRequest(
    @Args('id') materialRequestId: string,
    @Args('updateMaterialRequestInput')
    updateMaterialRequestInput: UpdateMaterialRequestInput,
  ) {
    return this.materialRequestService.updateMaterialRequest(
      materialRequestId,
      updateMaterialRequestInput,
    );
  }

  @Mutation(() => MaterialRequestVoucher)
  async deleteMaterialRequest(@Args('id') materialRequestId: string) {
    return this.materialRequestService.deleteMaterialRequest(materialRequestId);
  }
}
