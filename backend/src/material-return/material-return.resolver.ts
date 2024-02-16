import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { MaterialReturnService } from './material-return.service';
import { MaterialReturnVoucher } from './model/material-return.model';
import { CreateMaterialReturnInput } from './dto/create-material-return.input';
import { UpdateMaterialReturnInput } from './dto/update-material-return.input';

@Resolver('MaterialReturn')
export class MaterialReturnResolver {
  constructor(
    private readonly materialReturnService: MaterialReturnService,
  ) {}

  @Query(() => [MaterialReturnVoucher])
  async getMaterialReturns() {
    return this.materialReturnService.getMaterialReturns();
  }

  @Query(() => MaterialReturnVoucher)
  async getMaterialReturnById(@Args('id') materialReturnId: string) {
    return this.materialReturnService.getMaterialReturnById(
      materialReturnId,
    );
  }

  @Mutation(() => MaterialReturnVoucher)
  async createMaterialReturn(
    @Args('createMaterialReturnInput')
    createMaterialReturn: CreateMaterialReturnInput,
  ) {
    try {
      return await this.materialReturnService.createMaterialReturn(
        createMaterialReturn,
      );
    } catch (e) {
      console.log(e);
      return e;
    }
  }

  @Mutation(() => MaterialReturnVoucher)
  async updateMaterialReturn(
    @Args('id') materialReturnId: string,
    @Args('updateMaterialReturnInput')
    updateMaterialReturnInput: UpdateMaterialReturnInput,
  ) {
    return this.materialReturnService.updateMaterialReturn(
      materialReturnId,
      updateMaterialReturnInput,
    );
  }

  @Mutation(() => MaterialReturnVoucher)
  async deleteMaterialReturn(@Args('id') materialReturnId: string) {
    return this.materialReturnService.deleteMaterialReturn(materialReturnId);
  }
}
