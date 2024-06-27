/*
  Warnings:

  - A unique constraint covering the columns `[companyId,name,location]` on the table `WarehouseStore` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "WarehouseStore_name_location_key";

-- CreateIndex
CREATE UNIQUE INDEX "WarehouseStore_companyId_name_location_key" ON "WarehouseStore"("companyId", "name", "location");
