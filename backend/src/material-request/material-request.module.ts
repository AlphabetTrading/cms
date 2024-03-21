import { Module } from '@nestjs/common';
import { MaterialRequestService } from './material-request.service';
import { MaterialRequestResolver } from './material-request.resolver';

@Module({
  providers: [MaterialRequestService, MaterialRequestResolver],
  exports: [MaterialRequestService]
})
export class MaterialRequestModule {}
