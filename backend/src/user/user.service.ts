import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreateUserInput } from './dto/create-user.input';
import { UpdateUserInput } from './dto/update-user.input';
import { PasswordService } from 'src/auth/password.service';
import { User, UserRole } from '@prisma/client';
import { CreateOwnerInput } from './dto/create-owner.input';
import { v4 as uuidv4 } from 'uuid';
import { RegistrationInput } from 'src/auth/dto/registration.input';

@Injectable()
export class UserService {
  constructor(
    private prisma: PrismaService,
    private readonly passwordService: PasswordService,
  ) {}

  async createOwner(createOwner: CreateOwnerInput): Promise<any | null> {
    try {
      const existingUser = await this.prisma.user.findUnique({
        where: {
          email: createOwner.email,
          phoneNumber: createOwner.phoneNumber,
        },
      });

      if (existingUser) {
        throw new BadRequestException('User already exists!');
      }

      const invitationToken = uuidv4();
      const newOwner = await this.prisma.user.create({
        data: {
          ...createOwner,
          role: UserRole.OWNER,
          invitationToken,
          invited: true,
        },
      });
      return newOwner;
    } catch (e) {
      return e;
    }
  }

  async createUser(createUser: CreateUserInput): Promise<any | null> {
    try {
      const existingUser = await this.prisma.user.findUnique({
        where: {
          email: createUser.email,
          phoneNumber: createUser.phoneNumber,
        },
      });

      if (existingUser) {
        throw new BadRequestException('User already exists!');
      }

      const invitationToken = uuidv4();
      const newUser = await this.prisma.user.create({
        data: {
          ...createUser,
          role: createUser.role,
          invitationToken,
          invited: true,
        },
      });
      return newUser;
    } catch (e) {
      return e;
    }
  }

  async registerUser(registerUser: RegistrationInput) {
    try {
      const user = await this.prisma.user.findFirst({
        where: { invitationToken: registerUser.token },
      });
      if (!user) {
        throw new Error('Invalid token.');
      }

      if (registerUser.password !== registerUser.confirmPassword) {
        throw new BadRequestException('Passwords must match!');
      }
      
      const hashedPassword = await this.passwordService.hashPassword(
        registerUser.password,
      );

      await this.prisma.user.update({
        where: { id: user.id },
        data: {
          password: hashedPassword,
          invitationToken: null,
          invited: false,
        },
      });
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

  async findUserByPhoneNumber(phoneNumber: string): Promise<User | null> {
    const user = await this.prisma.user.findUnique({
      where: { phoneNumber },
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
