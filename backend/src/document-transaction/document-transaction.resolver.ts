import { Resolver, Query, Args } from '@nestjs/graphql';
import { DocumentTransactionService } from './document-transaction.service';
import { DocumentTransaction } from './model/document-transaction-model';
import { User } from '@prisma/client';
import { UserEntity } from 'src/common/decorators';
import { UseGuards } from '@nestjs/common';
import { GqlAuthGuard } from 'src/auth/guards/gql-auth.guard';

@Resolver(() => DocumentTransaction)
export class DocumentTransactionResolver {
  constructor(
    private readonly documentTransactionService: DocumentTransactionService,
  ) {}

  @UseGuards(GqlAuthGuard)
  @Query(() => [DocumentTransaction])
  async getAllDocumentsStatus(
    @UserEntity() user: User,
    @Args('projectId', {
      type: () => String,
    })
    projectId: string,
  ): Promise<DocumentTransaction[]> {
    return this.documentTransactionService.getAllDocumentsStatus(
      user.id,
      projectId,
    );
  }
}
