import { Module } from '@nestjs/common';
import { MaterialTransferService } from './material-transfer.service';
import { MaterialTransferResolver } from './material-transfer.resolver';

@Module({
  providers: [MaterialTransferResolver, MaterialTransferService],
  exports: [MaterialTransferService],
})
export class MaterialTransferModule {}
