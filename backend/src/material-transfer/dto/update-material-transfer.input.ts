import { IsString, ValidateNested } from 'class-validator';
import { InputType, Field } from '@nestjs/graphql';
import { Type } from 'class-transformer';
import { UpdateMaterialTransferItemInput } from './update-material-transfer-item.input';

@InputType()
export class UpdateMaterialTransferInput {
  @IsString()
  @Field(() => String)
  id: string;

  @IsString()
  @Field(() => String, { nullable: true })
  projectId?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  requisitionNumber?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  materialGroup?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  sendingStore?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  receivingStore?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  vehiclePlateNo?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  sentThroughName?: string;

  @ValidateNested({ each: true })
  @Type(() => UpdateMaterialTransferItemInput)
  @Field(() => [UpdateMaterialTransferItemInput], { nullable: true })
  items?: UpdateMaterialTransferItemInput[];

  @IsString()
  @Field(() => String, { nullable: true })
  materialReceiveId?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  preparedById?: string;

  @IsString()
  @Field(() => String, { nullable: true })
  approvedById?: string;
}
