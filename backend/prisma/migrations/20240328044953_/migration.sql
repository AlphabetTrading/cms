/*
  Warnings:

  - You are about to drop the column `warehouseProductId` on the `PriceHistory` table. All the data in the column will be lost.
  - You are about to drop the column `currentPrice` on the `WarehouseProduct` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "PriceHistory" DROP CONSTRAINT "PriceHistory_warehouseProductId_fkey";

-- AlterTable
ALTER TABLE "PriceHistory" DROP COLUMN "warehouseProductId";

-- AlterTable
ALTER TABLE "WarehouseProduct" DROP COLUMN "currentPrice";
