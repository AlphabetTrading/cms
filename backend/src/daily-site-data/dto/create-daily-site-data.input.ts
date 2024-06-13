import { InputType, Field } from '@nestjs/graphql';
import { IsNotEmpty, IsOptional, ValidateNested } from 'class-validator';
import { CreateDailySiteDataTaskInput } from './create-daily-site-data-task.input';

@InputType()
export class CreateDailySiteDataInput {
  @IsNotEmpty()
  @Field(() => String)
  projectId: string;

  @IsNotEmpty()
  @Field(() => Date)
  date: Date;

  @IsOptional()
  @Field(() => String, { nullable: true })
  contractor?: string;

  @ValidateNested({ each: true })
  @Field(() => [CreateDailySiteDataTaskInput])
  tasks: CreateDailySiteDataTaskInput[];

  @IsNotEmpty()
  @Field(() => String)
  preparedById: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  checkedById?: string;

  @IsOptional()
  @Field(() => String, { nullable: true })
  approvedById?: string;
}
