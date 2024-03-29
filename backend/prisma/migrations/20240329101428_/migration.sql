/*
  Warnings:

  - A unique constraint covering the columns `[productId,warehouseId]` on the table `WarehouseProduct` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "WarehouseStore_location_key";

-- DropIndex
DROP INDEX "WarehouseStore_name_key";

-- CreateIndex
CREATE UNIQUE INDEX "WarehouseProduct_productId_warehouseId_key" ON "WarehouseProduct"("productId", "warehouseId");
