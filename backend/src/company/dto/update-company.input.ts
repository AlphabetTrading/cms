import { CreateCompanyInput } from './create-company.input';
import { InputType, Field, PartialType } from '@nestjs/graphql';

@InputType()
export class UpdateCompanyInput extends PartialType(CreateCompanyInput) {
  @Field(() => String, { nullable: true })
  name?: string;

  @Field(() => String, { nullable: true })
  address?: string;

  @Field(() => String, { nullable: true })
  contactInfo?: string;

  @Field(() => String, { nullable: true })
  ownerId?: string;
}
