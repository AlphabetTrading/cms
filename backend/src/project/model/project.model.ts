import { Field, Float, ObjectType } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/Base.model';

@ObjectType()
export class Project extends BaseModel {
  @Field()
  name: string;

  @Field()
  startDate: Date;

  @Field({ nullable: true })
  endDate?: Date;

  @Field(() => Float)
  budget: number;

  @Field()
  clientId: string;

  @Field()
  projectManagerId: string;

  @Field()
  status: string;
}