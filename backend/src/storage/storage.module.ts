import { Module } from '@nestjs/common';
import { StorageService } from './storage.service';
import { StorageResolver } from './storage.resolver';

@Module({
  providers: [StorageService, StorageResolver],
  exports: [StorageService, StorageResolver],
})
export class StorageModule {}
