import { Module } from '@nestjs/common';
import { MaterialReturnService } from './material-return.service';
import { MaterialReturnResolver } from './material-return.resolver';

@Module({
  providers: [MaterialReturnService, MaterialReturnResolver]
})
export class MaterialReturnModule {}
