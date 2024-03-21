import { Field, ObjectType, registerEnumType } from '@nestjs/graphql';
import { DocumentType } from 'src/common/enums/document-type';

registerEnumType(DocumentType, {
  name: 'DocumentType',
});

@ObjectType()
export class DocumentTransaction {
  @Field(() => Number)
  approvedCount: number;

  @Field(() => Number)
  declinedCount: number;

  @Field(() => Number)
  pendingCount: number;

  @Field(() => DocumentType)
  type: DocumentType;
}
