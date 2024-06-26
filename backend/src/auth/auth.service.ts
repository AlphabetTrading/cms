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
import { Token } from './models/token.model';

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
      const user = await this.userService.findUserByPhoneNumber(
        loginInput.phone_number,
      );
      if (
        user &&
        (await this.passwordService.comparePasswords(
          loginInput.password,
          user.password,
        ))
      ) {
        const { accessToken, refreshToken } = this.generateTokens({
          userId: user.id,
        });
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

  async validateUser(userId: string): Promise<User> {
    return await this.prismaService.user.findUnique({
      where: { id: userId },
    });
  }

  getUserFromToken(token: string): Promise<User> {
    const id = this.jwtService.decode(token)['userId'];
    return this.prismaService.user.findUnique({
      where: { id },
    });
  }

  generateTokens(payload: { userId: string }): Token {
    return {
      accessToken: this.generateAccessToken(payload),
      refreshToken: this.generateRefreshToken(payload),
    };
  }

  private generateAccessToken(payload: { userId: string }): string {
    return this.jwtService.sign(payload, {
      secret: this.configService.get('JWT_ACCESS_SECRET'),
      expiresIn: this.configService.get('EXPIRE_IN'),
    });
  }
  private generateRefreshToken(payload: { userId: string }): string {
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

      return this.generateTokens({ userId });
    } catch (e) {
      throw new UnauthorizedException();
    }
  }
}
