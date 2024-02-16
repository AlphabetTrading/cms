// user.resolver.ts

import { Resolver, Query, Mutation, Args } from '@nestjs/graphql';
import { UserService } from './user.service';
import { CreateUserInput } from './dto/create-user.input';
import { UpdateUserInput } from './dto/update-user.input';
import { User } from './user.model';
// import { UserEntity } from 'src/common/decorators';

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

  @Query(() => [User])
  async getUsers() {
    return this.userService.findUsers();
  }

  @Query(() => User)
  async getUserByEmail(@Args('email') email: string) {
    return this.userService.findUserByEmail(email);
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
}
