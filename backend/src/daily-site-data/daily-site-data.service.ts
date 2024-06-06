import { Injectable } from '@nestjs/common';
import { CreateDailySiteDatumInput } from './dto/create-daily-site-datum.input';
import { UpdateDailySiteDatumInput } from './dto/update-daily-site-datum.input';

@Injectable()
export class DailySiteDataService {
  create(createDailySiteDatumInput: CreateDailySiteDatumInput) {
    return 'This action adds a new dailySiteDatum';
  }

  findAll() {
    return `This action returns all dailySiteData`;
  }

  findOne(id: number) {
    return `This action returns a #${id} dailySiteDatum`;
  }

  update(id: number, updateDailySiteDatumInput: UpdateDailySiteDatumInput) {
    return `This action updates a #${id} dailySiteDatum`;
  }

  remove(id: number) {
    return `This action removes a #${id} dailySiteDatum`;
  }
}
