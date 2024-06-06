import { Resolver, Query, Mutation, Args, Int } from '@nestjs/graphql';
import { DailySiteDataService } from './daily-site-data.service';
import { DailySiteDatum } from './model/daily-site-datum.entity';
import { CreateDailySiteDatumInput } from './dto/create-daily-site-datum.input';
import { UpdateDailySiteDatumInput } from './dto/update-daily-site-datum.input';

@Resolver(() => DailySiteDatum)
export class DailySiteDataResolver {
  constructor(private readonly dailySiteDataService: DailySiteDataService) {}

  @Mutation(() => DailySiteDatum)
  createDailySiteDatum(@Args('createDailySiteDatumInput') createDailySiteDatumInput: CreateDailySiteDatumInput) {
    return this.dailySiteDataService.create(createDailySiteDatumInput);
  }

  @Query(() => [DailySiteDatum], { name: 'dailySiteData' })
  findAll() {
    return this.dailySiteDataService.findAll();
  }

  @Query(() => DailySiteDatum, { name: 'dailySiteDatum' })
  findOne(@Args('id', { type: () => Int }) id: number) {
    return this.dailySiteDataService.findOne(id);
  }

  @Mutation(() => DailySiteDatum)
  updateDailySiteDatum(@Args('updateDailySiteDatumInput') updateDailySiteDatumInput: UpdateDailySiteDatumInput) {
    return this.dailySiteDataService.update(updateDailySiteDatumInput.id, updateDailySiteDatumInput);
  }

  @Mutation(() => DailySiteDatum)
  removeDailySiteDatum(@Args('id', { type: () => Int }) id: number) {
    return this.dailySiteDataService.remove(id);
  }
}
