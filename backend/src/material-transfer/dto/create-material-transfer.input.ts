import { InputType, Field } from '@nestjs/graphql';
import { IsNotEmpty, ValidateNested, IsOptional } from 'class-validator';
import { CreateMaterialTransferItemInput } from './create-material-transfer-item.input';

@InputType()
export class CreateMaterialTransferInput {
  @IsNotEmpty()
  @Field(() => String)
  projectId: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  requisitionNumber?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  materialGroup?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  sendingWarehouseStoreId?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  vehiclePlateNo?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  receivingWarehouseStoreId?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  sentThroughName?: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateMaterialTransferItemInput])
  items: CreateMaterialTransferItemInput[];

  @IsNotEmpty()
  @Field(() => String)
  materialReceiveId: string;

  @IsNotEmpty()
  @Field(() => String)
  preparedById: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;
}
