import { Field, InputType } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional, ValidateNested } from 'class-validator';
import { CreateProformaItemInput } from './create-proforma-item.input';

@InputType()
export class CreateProformaInput {
  @IsNotEmpty()
  @Field(() => String)
  projectId: string;

  @IsNotEmpty()
  @Field(() => String)
  materialRequestItemId: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateProformaItemInput])
  items: CreateProformaItemInput[];

  @IsNotEmpty()
  @Field(() => String)
  preparedById: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;
}
