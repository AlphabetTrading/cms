import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { PurchaseOrderService } from './purchase-order.service';
import { PurchaseOrderVoucher } from './model/purchase-order.model';
import { CreatePurchaseOrderInput } from './dto/create-purchase-order.input';
import { UpdatePurchaseOrderInput } from './dto/update-purchase-order.input';

@Resolver('PurchaseOrder')
export class PurchaseOrderResolver {
  constructor(private readonly purchaseOrderService: PurchaseOrderService) {}

  @Query(() => [PurchaseOrderVoucher])
  async getPurchaseOrders() {
    return this.purchaseOrderService.getPurchaseOrders();
  }

  @Query(() => PurchaseOrderVoucher)
  async getPurchaseOrderById(@Args('id') purchaseOrderId: string) {
    return this.purchaseOrderService.getPurchaseOrderById(purchaseOrderId);
  }

  @Mutation(() => PurchaseOrderVoucher)
  async createPurchaseOrder(
    @Args('createPurchaseOrderInput')
    createPurchaseOrder: CreatePurchaseOrderInput,
  ) {
    try {
      return await this.purchaseOrderService.createPurchaseOrder(
        createPurchaseOrder,
      );
    } catch (e) {
      console.log(e);
      return e;
    }
  }

  @Mutation(() => PurchaseOrderVoucher)
  async updatePurchaseOrder(
    @Args('id') purchaseOrderId: string,
    @Args('updatePurchaseOrderInput')
    updatePurchaseOrderInput: UpdatePurchaseOrderInput,
  ) {
    return this.purchaseOrderService.updatePurchaseOrder(
      purchaseOrderId,
      updatePurchaseOrderInput,
    );
  }

  @Mutation(() => PurchaseOrderVoucher)
  async deletePurchaseOrder(@Args('id') purchaseOrderId: string) {
    return this.purchaseOrderService.deletePurchaseOrder(purchaseOrderId);
  }
}
