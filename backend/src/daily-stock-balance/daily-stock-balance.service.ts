import { Injectable } from '@nestjs/common';
import { CreateDailyStockBalanceInput } from './dto/create-daily-stock-balance.input';
import { UpdateDailyStockBalanceInput } from './dto/update-daily-stock-balance.input';

@Injectable()
export class DailyStockBalanceService {
  create(createDailyStockBalanceInput: CreateDailyStockBalanceInput) {
    return 'This action adds a new dailyStockBalance';
  }

  findAll() {
    return `This action returns all dailyStockBalance`;
  }

  findOne(id: number) {
    return `This action returns a #${id} dailyStockBalance`;
  }

  update(id: number, updateDailyStockBalanceInput: UpdateDailyStockBalanceInput) {
    return `This action updates a #${id} dailyStockBalance`;
  }

  remove(id: number) {
    return `This action removes a #${id} dailyStockBalance`;
  }
}
