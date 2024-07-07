import { ObjectType, Field } from '@nestjs/graphql';
import { BaseModel } from 'src/common/models/base.model';
import { Company } from 'src/company/model/company.model';
import { ProductVariant } from 'src/product-variant/model/product-variant.model';

@ObjectType()
export class PriceHistory extends BaseModel {
  @Field({ nullable: true })
  productVariantId?: string;

  @Field(() => ProductVariant, { nullable: true })
  productVariant?: ProductVariant;

  @Field({ nullable: true })
  companyId?: string;

  @Field(() => Company, { nullable: true })
  company?: Company;

  @Field({ nullable: true })
  price?: number;
}
