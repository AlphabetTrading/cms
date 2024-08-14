import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional, ValidateNested } from 'class-validator';
import { CreateMaterialReceiveItemInput } from './create-material-receive-item.input';

@InputType()
export class CreateMaterialReceiveInput {
  @IsNotEmpty()
  @Field(() => String)
  projectId: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateMaterialReceiveItemInput])
  items: CreateMaterialReceiveItemInput[];

  @IsNotEmpty()
  @Field(() => String)
  preparedById: string;

  @IsNotEmpty()
  @Field(() => String)
  warehouseStoreId: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;
}
