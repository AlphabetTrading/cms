import {
  Args,
  Mutation,
  Resolver,
} from '@nestjs/graphql';
import { Auth } from './models/auth.model';
import { AuthService } from './auth.service';
import { LoginInput } from './dto/login.input';
import { RefreshTokenInput } from './dto/refresh-token.input';
import { Token } from './models/token.model';

@Resolver(() => Auth)
export class AuthResolver {
  constructor(private readonly auth: AuthService) {}

  @Mutation(() => Auth)
  async login(@Args('data') loginInput: LoginInput) {
    try {
      const user = await this.auth.login(loginInput);
      console.log(user)
      return user
    } catch (error) {
      return error;
    }
  }

  @Mutation(() => Token)
  async refreshToken(@Args() data: RefreshTokenInput) {
    return this.auth.refreshToken(data.refreshToken);
  }

//   @ResolveField('user', () => User)
//   async user(@Parent() auth: Auth) {
//     return await this.auth.getUserFromToken(auth.accessToken);
//   }
}
