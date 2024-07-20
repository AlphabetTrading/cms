/*
  Warnings:

  - You are about to drop the column `photo` on the `ProformaItem` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "ProformaItem" DROP COLUMN "photo",
ADD COLUMN     "photos" TEXT[];
