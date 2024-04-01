import { Args, Mutation, Parent, ResolveField, Resolver } from '@nestjs/graphql';
import { Auth } from './models/auth.model';
import { AuthService } from './auth.service';
import { LoginInput } from './dto/login.input';
import { RefreshTokenInput } from './dto/refresh-token.input';
import { Token } from './models/token.model';
import { User } from 'src/user/user.model';

@Resolver(() => Auth)
export class AuthResolver {
  constructor(private readonly auth: AuthService) {}

  @Mutation(() => Auth)
  async login(@Args('data') loginInput: LoginInput) {
    try {
      const user = await this.auth.login(loginInput);
      return user;
    } catch (error) {
      return error;
    }
  }

  @Mutation(() => Token)
  async refreshToken(@Args() data: RefreshTokenInput) {
    const { accessToken, refreshToken } = this.auth.refreshToken(
      data.refreshToken,
    );

    return {
      accessToken,
      refreshToken,
    };
  }

  @ResolveField('user', () => User)
  async user(@Parent() auth: Auth) {
    return await this.auth.getUserFromToken(auth.accessToken);
  }


  //   @ResolveField('user', () => User)
  //   async user(@Parent() auth: Auth) {
  //     return await this.auth.getUserFromToken(auth.accessToken);
  //   }
}
