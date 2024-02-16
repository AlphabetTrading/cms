import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserResolver } from './user.resolver';
import { PasswordService } from 'src/auth/password.service';

@Module({
  providers: [UserService, UserResolver, PasswordService],
  exports: [UserService],
})
export class UserModule {}
