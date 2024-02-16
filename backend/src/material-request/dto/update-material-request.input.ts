import { Field, InputType } from '@nestjs/graphql';
import { ValidateNested } from 'class-validator';
import { UpdateMaterialRequestItemInput } from './update-material-request-item.input';

@InputType()
export class UpdateMaterialRequestInput {
  @Field(() => Date, { nullable: true })
  date?: Date;

  @Field(() => String, { nullable: true })
  from?: string;

  @Field(() => String, { nullable: true })
  to?: string;

  @ValidateNested({ each: true })
  @Field(() => [UpdateMaterialRequestItemInput], { nullable: true })
  items?: UpdateMaterialRequestItemInput[];

  @Field(() => String, { nullable: true })
  requestedById?: string;

  @Field(() => String, { nullable: true })
  approvedById?: string;
}
