import { Field, ObjectType } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';

@ObjectType()
export class Proforma extends BaseModel {
  @Field({ nullable: true })
  projectId?: string;

  @Field(() => String, { nullable: true })
  serialNumber?: string;

  @Field(() => String)
  materialRequestId?: string;

  @Field(() => String)
  vendor?: string;

  @Field(() => [String])
  photos?: string[];
}
