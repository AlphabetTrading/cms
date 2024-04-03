import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional, ValidateNested } from 'class-validator';
import { CreateMaterialRequestItemInput } from './create-material-request-item.input';

@InputType()
export class CreateMaterialRequestInput {
  @IsNotEmpty()
  @Field(() => String)
  projectId: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateMaterialRequestItemInput])
  items: CreateMaterialRequestItemInput[];

  @IsNotEmpty()
  @Field(() => String)
  requestedById: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;
}
