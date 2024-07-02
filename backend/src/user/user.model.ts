import { Field, ObjectType, registerEnumType } from '@nestjs/graphql';
import { UserRole } from '@prisma/client';
import { BaseModel } from 'src/common/models/base.model';
import { Company } from 'src/company/model/company.model';

registerEnumType(UserRole, {
  name: 'UserRole',
});

@ObjectType()
export class User extends BaseModel {
  @Field()
  fullName: string;

  @Field()
  email: string;

  @Field()
  phoneNumber: string;

  @Field()
  role: UserRole;

  @Field(() => Company, { nullable: true })
  company?: Company;
}
