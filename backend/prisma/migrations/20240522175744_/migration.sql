/*
  Warnings:

  - You are about to drop the column `productId` on the `PriceHistory` table. All the data in the column will be lost.
  - You are about to drop the column `warehouseStoreId` on the `PurchaseOrder` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[productVariantId,warehouseId,projectId]` on the table `WarehouseProduct` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `productVariantId` to the `PriceHistory` table without a default value. This is not possible if the table is not empty.
  - Added the required column `projectId` to the `PriceHistory` table without a default value. This is not possible if the table is not empty.
  - Added the required column `currentPrice` to the `WarehouseProduct` table without a default value. This is not possible if the table is not empty.
  - Added the required column `projectId` to the `WarehouseProduct` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "PriceHistory" DROP CONSTRAINT "PriceHistory_productId_fkey";

-- DropForeignKey
ALTER TABLE "PurchaseOrder" DROP CONSTRAINT "PurchaseOrder_warehouseStoreId_fkey";

-- DropIndex
DROP INDEX "WarehouseProduct_productVariantId_warehouseId_key";

-- AlterTable
ALTER TABLE "MaterialReceiveVoucher" ADD COLUMN     "warehouseStoreId" TEXT;

-- AlterTable
ALTER TABLE "PriceHistory" DROP COLUMN "productId",
ADD COLUMN     "productVariantId" TEXT NOT NULL,
ADD COLUMN     "projectId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "PurchaseOrder" DROP COLUMN "warehouseStoreId";

-- AlterTable
ALTER TABLE "WarehouseProduct" ADD COLUMN     "currentPrice" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "projectId" TEXT NOT NULL;

-- CreateIndex
CREATE INDEX "PriceHistory_productVariantId_projectId_idx" ON "PriceHistory"("productVariantId", "projectId");

-- CreateIndex
CREATE UNIQUE INDEX "WarehouseProduct_productVariantId_warehouseId_projectId_key" ON "WarehouseProduct"("productVariantId", "warehouseId", "projectId");

-- AddForeignKey
ALTER TABLE "WarehouseProduct" ADD CONSTRAINT "WarehouseProduct_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PriceHistory" ADD CONSTRAINT "PriceHistory_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PriceHistory" ADD CONSTRAINT "PriceHistory_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveVoucher" ADD CONSTRAINT "MaterialReceiveVoucher_warehouseStoreId_fkey" FOREIGN KEY ("warehouseStoreId") REFERENCES "WarehouseStore"("id") ON DELETE SET NULL ON UPDATE CASCADE;
