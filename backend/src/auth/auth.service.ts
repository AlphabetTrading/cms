import {
  Injectable,
  UnauthorizedException,
  //   BadRequestException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { UserService } from 'src/user/user.service';
import { User } from 'src/user/user.model';
import { PasswordService } from './password.service';
import { LoginInput } from './dto/login.input';
import { PrismaService } from 'src/prisma.service';
import { Auth } from './models/auth.model';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly passwordService: PasswordService,
    private readonly prismaService: PrismaService,
    private readonly userService: UserService,
    private readonly configService: ConfigService,
  ) {}

  async login(loginInput: LoginInput): Promise<Auth> {
    try {
      const user = await this.userService.findUserByPhoneNumber(loginInput.phone_number);
      if (
        user &&
        (await this.passwordService.comparePasswords(
          loginInput.password,
          user.password,
        ))
      ) {
        const { accessToken, refreshToken } = this.generateTokens(user.id);
        return {
          userId: user.id,
          accessToken: accessToken,
          refreshToken: refreshToken,
        };
      }
      throw new UnauthorizedException('Invalid Credentials');
    } catch (e) {
      return e;
    }
  }

  async validateUser(email: string): Promise<User | null> {
    const user = await this.userService.findUserByEmail(email);
    if (user) return user;

    return null;
  }

  getUserFromToken(token: string): Promise<User> {
    const id = this.jwtService.decode(token)['userId'];
    console.log(id)
    return this.prismaService.user.findUnique({
      where: { id },
    });
  }

  generateTokens(userId: string): {
    accessToken: string;
    refreshToken: string;
  } {
    const accessToken = this.generateAccessToken(userId);
    const refreshToken = this.generateRefreshToken(userId);

    return { accessToken, refreshToken };
  }

  private generateAccessToken(userId: string): string {
    const payload = { sub: userId };
    return this.jwtService.sign(payload, {
      secret: this.configService.get('JWT_ACCESS_SECRET'),
      expiresIn: this.configService.get('EXPIRE_IN'),
    });
  }

  private generateRefreshToken(userId: string): string {
    const payload = { sub: userId };
    return this.jwtService.sign(payload, {
      secret: this.configService.get('JWT_REFRESH_SECRET'),
      expiresIn: this.configService.get('REFRESH_IN'),
    });
  }

  verifyToken(token: string): any {
    return this.jwtService.verify(token);
  }

  refreshToken(token: string) {
    try {
      const { userId } = this.jwtService.verify(token, {
        secret: this.configService.get('JWT_REFRESH_SECRET'),
      });

      return this.generateTokens(userId);
    } catch (e) {
      console.log(e);
      throw new UnauthorizedException();
    }
  }
}
