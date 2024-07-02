import { Module } from '@nestjs/common';
import { ProformaService } from './proforma.service';
import { ProformaResolver } from './proforma.resolver';
import { StorageModule } from 'src/storage/storage.module';

@Module({
  providers: [ProformaResolver, ProformaService],
  imports: [StorageModule],
  exports: [ProformaService],
})
export class ProformaModule {}
