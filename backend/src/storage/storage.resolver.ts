import { Args, Mutation, Resolver } from '@nestjs/graphql';
import {
  BadRequestException,
  InternalServerErrorException,
} from '@nestjs/common';
import { StorageService } from './storage.service';
import * as GraphQLUpload from 'graphql-upload/GraphQLUpload.js';
import * as FileUpload from 'graphql-upload/Upload.js';
import { v4 as uuidv4 } from 'uuid';
@Resolver()
export class StorageResolver {
  constructor(private readonly storageService: StorageService) {}

  @Mutation(() => String)
  async uploadFile(
    @Args('file', { type: () => GraphQLUpload })
    file: FileUpload,
  ) {
    try {
      const allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      const fileExtension = file.filename.split('.').pop().toLowerCase();
  
      if (!allowedExtensions.includes(fileExtension)) {
        throw new BadRequestException('File type must be an image');
      }
  
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

      const newFilename = `${uuidv4()}.${fileExtension}`;

      const fileData = await this.storageService.uploadPublicFile(
        buffer,
        newFilename,
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
