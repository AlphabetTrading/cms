import { Module } from '@nestjs/common';
import { ProformaService } from './proforma.service';
import { ProformaResolver } from './proforma.resolver';

@Module({
  providers: [ProformaResolver, ProformaService],
  exports: [ProformaService],
})
export class ProformaModule {}
