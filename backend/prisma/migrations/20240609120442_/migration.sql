/*
  Warnings:

  - Added the required column `loadingCost` to the `MaterialReceiveItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transportationCost` to the `MaterialReceiveItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `unloadingCost` to the `MaterialReceiveItem` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "MaterialReceiveItem" ADD COLUMN     "loadingCost" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "transportationCost" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "unloadingCost" DOUBLE PRECISION NOT NULL;
