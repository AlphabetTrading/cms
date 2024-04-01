import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, ValidateNested } from 'class-validator';
import { CreateMaterialRequestItemInput } from './create-material-request-item.input';

@InputType()
export class CreateMaterialRequestInput {
  @ValidateNested({ each: true })
  @Field(() => [CreateMaterialRequestItemInput])
  items: CreateMaterialRequestItemInput[];

  @IsNotEmpty()
  @Field(() => String)
  requestedById: string;

  @IsNotEmpty()
  @Field(() => String)
  approvedById: string;
}
