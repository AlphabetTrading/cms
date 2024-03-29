/*
  Warnings:

  - A unique constraint covering the columns `[name]` on the table `WarehouseStore` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[location]` on the table `WarehouseStore` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name,location]` on the table `WarehouseStore` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "WarehouseStore_name_key" ON "WarehouseStore"("name");

-- CreateIndex
CREATE UNIQUE INDEX "WarehouseStore_location_key" ON "WarehouseStore"("location");

-- CreateIndex
CREATE UNIQUE INDEX "WarehouseStore_name_location_key" ON "WarehouseStore"("name", "location");
