import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional, ValidateNested } from 'class-validator';
import { CreateMaterialReturnItemInput } from './create-material-return-item.input';

@InputType()
export class CreateMaterialReturnInput {
  @IsNotEmpty()
  @Field(() => String)
  projectId: string;

  @IsNotEmpty()
  @Field(() => String)
  receivingWarehouseStoreId: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateMaterialReturnItemInput])
  items: CreateMaterialReturnItemInput[];

  @IsNotEmpty()
  @Field(() => String)
  returnedById: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  receivedById?: string;
}
