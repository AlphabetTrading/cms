import { Module } from '@nestjs/common';
import { MaterialReceiveService } from './material-receive.service';
import { MaterialReceiveResolver } from './material-receive.resolver';

@Module({
  providers: [MaterialReceiveService, MaterialReceiveResolver]
})
export class MaterialReceiveModule {}
