import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { MaterialReceiveService } from './material-receive.service';
import { MaterialReceiveVoucher } from './model/material-receive.model';
import { CreateMaterialReceiveInput } from './dto/create-material-receive.input';
import { UpdateMaterialReceiveInput } from './dto/update-material-receive.input';

@Resolver('MaterialReceive')
export class MaterialReceiveResolver {
  constructor(
    private readonly materialReceiveService: MaterialReceiveService,
  ) {}

  @Query(() => [MaterialReceiveVoucher])
  async getMaterialReceives() {
    return this.materialReceiveService.getMaterialReceives();
  }

  @Query(() => MaterialReceiveVoucher)
  async getMaterialReceiveById(@Args('id') materialReceiveId: string) {
    return this.materialReceiveService.getMaterialReceiveById(materialReceiveId);
  }

  @Mutation(() => MaterialReceiveVoucher)
  async createMaterialReceive(
    @Args('createMaterialReceiveInput')
    createMaterialReceive: CreateMaterialReceiveInput,
  ) {
    try {
      return await this.materialReceiveService.createMaterialReceive(
        createMaterialReceive,
      );
    } catch (e) {
      console.log(e);
      return e;
    }
  }

  @Mutation(() => MaterialReceiveVoucher)
  async updateMaterialReceive(
    @Args('id') materialReceiveId: string,
    @Args('updateMaterialReceiveInput')
    updateMaterialReceiveInput: UpdateMaterialReceiveInput,
  ) {
    return this.materialReceiveService.updateMaterialReceive(
      materialReceiveId,
      updateMaterialReceiveInput,
    );
  }

  @Mutation(() => MaterialReceiveVoucher)
  async deleteMaterialReceive(@Args('id') materialReceiveId: string) {
    return this.materialReceiveService.deleteMaterialReceive(materialReceiveId);
  }
}
