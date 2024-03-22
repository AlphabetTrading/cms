import { Args, Mutation, Resolver } from '@nestjs/graphql';
import {
  BadRequestException,
  InternalServerErrorException,
} from '@nestjs/common';
import { StorageService } from './storage.service';
import * as GraphQLUpload from 'graphql-upload/GraphQLUpload.js';
import * as FileUpload from 'graphql-upload/Upload.js';

@Resolver()
export class StorageResolver {
  constructor(private readonly storageService: StorageService) {}

  @Mutation(() => String)
  async uploadFile(
    @Args('file', { type: () => GraphQLUpload })
    file: FileUpload,
  ) {
    try {
      if (
        ['JPG', 'JPEG', 'PNG', 'WEBP'].indexOf(
          file.filename.split('.').pop().toUpperCase(),
        ) == -1
      )
        throw new BadRequestException('File type must an image');

      const { createReadStream } = file;

      const stream = createReadStream();
      const chunks = [];

      const buffer = await new Promise<Buffer>((resolve, reject) => {
        let buffer: Buffer;

        stream.on('data', function (chunk) {
          chunks.push(chunk);
        });

        stream.on('end', function () {
          buffer = Buffer.concat(chunks);
          resolve(buffer);
        });

        stream.on('error', reject);
      });
      const fileData = await this.storageService.uploadPublicFile(
        buffer,
        file.filename,
      );
      return fileData.url;
    } catch (error) {
      throw new InternalServerErrorException(error.message);
    }
  }

  @Mutation(() => Boolean)
  async deleteFile(@Args('url') url: string) {
    try {
      await this.storageService.deleteS3Object(url);
      return true;
    } catch (error) {
      throw new InternalServerErrorException(error.message);
    }
  }
}
