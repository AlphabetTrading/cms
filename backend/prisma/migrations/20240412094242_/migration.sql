/*
  Warnings:

  - You are about to drop the column `productId` on the `WarehouseProduct` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[productVariantId,warehouseId]` on the table `WarehouseProduct` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `productVariantId` to the `WarehouseProduct` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "WarehouseProduct" DROP CONSTRAINT "WarehouseProduct_productId_fkey";

-- DropIndex
DROP INDEX "WarehouseProduct_productId_warehouseId_key";

-- AlterTable
ALTER TABLE "WarehouseProduct" DROP COLUMN "productId",
ADD COLUMN     "productVariantId" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "WarehouseProduct_productVariantId_warehouseId_key" ON "WarehouseProduct"("productVariantId", "warehouseId");

-- AddForeignKey
ALTER TABLE "WarehouseProduct" ADD CONSTRAINT "WarehouseProduct_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
