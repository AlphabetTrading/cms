import { Field, InputType } from '@nestjs/graphql';
import { ValidateNested } from 'class-validator';
import { UpdateMaterialReturnItemInput } from './update-material-return-item.input';

@InputType()
export class UpdateMaterialReturnInput {
  @Field(() => Date, { nullable: true })
  date?: Date;

  @Field(() => String, { nullable: true })
  from?: string;

  @Field(() => String, { nullable: true })
  receivingStore?: string;

  @ValidateNested({ each: true })
  @Field(() => [UpdateMaterialReturnItemInput], { nullable: true })
  items?: UpdateMaterialReturnItemInput[];

  @Field(() => String, { nullable: true })
  returnedById?: string;

  @Field(() => String, { nullable: true })
  receivedById?: string;

  @Field(() => Boolean, { nullable: true })
  received?: boolean;
}
