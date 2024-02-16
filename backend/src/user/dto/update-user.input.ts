// update-user.dto.ts

import { Field, InputType, PartialType } from '@nestjs/graphql';
import { CreateUserInput } from './create-user.input';
import { UserRole } from '@prisma/client';

@InputType()
export class UpdateUserInput extends PartialType(CreateUserInput) {
  @Field(() => String, { nullable: true })
  fullName?: string;

  @Field(() => UserRole, { nullable: true })
  role?: UserRole;
}
