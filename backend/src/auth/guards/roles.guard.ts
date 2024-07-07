import {
    Injectable,
    CanActivate,
    ExecutionContext,
    ForbiddenException,
  } from '@nestjs/common';
  import { Reflector } from '@nestjs/core';
  import { GqlExecutionContext } from '@nestjs/graphql';
  
  @Injectable()
  export class RolesGuard implements CanActivate {
    constructor(private reflector: Reflector) {}
  
    canActivate(context: ExecutionContext): boolean {
      const roles = this.reflector.get<string[]>('roles', context.getHandler());
      if (!roles) {
        return true;
      }
  
      const ctx = GqlExecutionContext.create(context);
      const { user } = ctx.getContext().req;
  
      if (!roles.includes(user.role)) {
        throw new ForbiddenException('You do not have permission to perform this action');
      }
  
      return true;
    }
  }
  