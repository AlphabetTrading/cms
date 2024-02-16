import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateUserInput } from './dto/create-user.input';
import { UpdateUserInput } from './dto/update-user.input';
import { PasswordService } from 'src/auth/password.service';
import { User } from '@prisma/client';

@Injectable()
export class UserService {
  constructor(
    private prisma: PrismaService,
    private readonly passwordService: PasswordService,
  ) {}

  async createUser(createUser: CreateUserInput): Promise<any | null> {
    try {
      const existingUser = await this.prisma.user.findUnique({
        where: { email: createUser.email },
      });

      if (createUser.password !== createUser.confirmPassword) {
        throw new BadRequestException('Passwords must match!');
      }

      delete createUser.confirmPassword;

      if (existingUser) {
        throw new BadRequestException('User already exists!');
      }

      const hashedPassword = await this.passwordService.hashPassword(
        createUser.password,
      );

      const newUser = await this.prisma.user.create({
        data: { ...createUser, password: hashedPassword },
      });

      delete newUser.password;
      return newUser;
    } catch (e) {
      return e;
    }
  }

  async findUsers(): Promise<User[]> {
    return await this.prisma.user.findMany();
  }

  async findUserByEmail(email: string): Promise<User | null> {
    const user = await this.prisma.user.findUnique({
      where: { email },
    });
    return user;
  }

  async getAllMyDocuments(userId: string): Promise<any[]> {
    const materialIssues = await this.prisma.materialIssueVoucher.findMany({
      where: { approvedById: userId },
    });

    const requests = await this.prisma.materialRequestVoucher.findMany({
      where: { approvedById: userId },
    });

    const receives = await this.prisma.materialReceiveVoucher.findMany({
      where: { approvedById: userId },
    });

    const purchaseOrders = await this.prisma.purchaseOrder.findMany({
      where: { approvedById: userId },
    });

    const allDocuments = [
      ...materialIssues,
      ...requests,
      ...receives,
      ...purchaseOrders,
    ];

    return allDocuments;
  }

  async updateUser(email: string, updateUser: UpdateUserInput): Promise<any> {
    const existingUser = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!existingUser) {
      throw new NotFoundException('User not found');
    }

    const updatedUser = await this.prisma.user.update({
      where: { email },
      data: updateUser,
    });

    return updatedUser;
  }

  async deleteUser(email: string): Promise<any> {
    const existingUser = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!existingUser) {
      throw new NotFoundException('User not found');
    }

    const deletedUser = await this.prisma.user.delete({
      where: { email },
    });

    return deletedUser;
  }
}
