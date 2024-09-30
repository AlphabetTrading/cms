// user.resolver.ts

import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { UserService } from './user.service';
import { CreateUserInput } from './dto/create-user.input';
import { UpdateUserInput } from './dto/update-user.input';
import { User } from './user.model';
import { CreateOwnerInput } from './dto/create-owner.input';
import { RegistrationInput } from 'src/auth/dto/registration.input';
import { UserEntity } from 'src/common/decorators';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';
import { BadRequestException, UseGuards } from '@nestjs/common';
import { FilterUserDocumentsInput } from './dto/filter-user-documents.input';
import { Prisma } from '@prisma/client';
// import { UserEntity } from 'src/common/decorators';

@UseGuards(GqlAuthGuard)
@Resolver('User')
export class UserResolver {
  constructor(private readonly userService: UserService) {}

  @Mutation(() => User)
  async createUser(@Args('createUser') createUser: CreateUserInput) {
    try {
      return await this.userService.createUser(createUser);
    } catch (error) {
      return error;
    }
  }

  @Mutation(() => User)
  async createCompanyOwner(@Args('createOwner') createOwner: CreateOwnerInput) {
    try {
      return await this.userService.createOwner(createOwner);
    } catch (error) {
      return error;
    }
  }

  @Mutation(() => User)
  async register(@Args('registerUser') registerUser: RegistrationInput) {
    try {
      return await this.userService.registerUser(registerUser);
    } catch (error) {
      return error;
    }
  }

  @Query(() => [User])
  async getUsers(
    @Args('filterUserInput', {
      type: () => FilterUserDocumentsInput,
      nullable: true,
    })
    filterUserInput?: FilterUserDocumentsInput,
  ) {
    const where: Prisma.UserWhereInput = {
      AND: [
        {
          id: filterUserInput?.id,
        },
        {
          OR: [
            {
              companyId: filterUserInput.companyId,
            },
            {
              fullName: filterUserInput?.fullName,
            },
            {
              role: {
                in: filterUserInput?.role,
              },
            },
            {
              email: filterUserInput?.email,
            },
            {
              phoneNumber: filterUserInput?.phoneNumber,
            },
          ],
        },
        {
          createdAt: filterUserInput?.createdAt,
        },
      ],
    };

    try {
      return await this.userService.findUsers({ where });
    } catch (e) {
      throw new BadRequestException('Error loading users!');
    }
  }

  @Query(() => User)
  async getUserByEmail(@Args('email') email: string) {
    return this.userService.findUserByEmail(email);
  }

  @Query(() => User)
  async getUserByPhoneNumber(@Args('phone_number') phone_number: string) {
    return this.userService.findUserByPhoneNumber(phone_number);
  }

  @Mutation(() => User)
  async updateUser(
    // @UserEntity() user: User,
    @Args('email') email: string,
    @Args('updateUser') updateUser: UpdateUserInput,
  ) {
    try {
      return await this.userService.updateUser(email, updateUser);
    } catch (error) {
      return error;
    }
  }

  @Mutation(() => User)
  async deleteUser(@Args('email') email: string) {
    try {
      const user = await this.userService.deleteUser(email);
      return user;
    } catch (error) {
      return error;
    }
  }

  @Query(() => User)
  async getMe(@UserEntity() user: User) {
    return this.userService.getMe(user.id);
  }
}
