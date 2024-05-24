/*
  Warnings:

  - Made the column `warehouseStoreId` on table `MaterialIssueVoucher` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "MaterialIssueVoucher" DROP CONSTRAINT "MaterialIssueVoucher_warehouseStoreId_fkey";

-- AlterTable
ALTER TABLE "MaterialIssueVoucher" ALTER COLUMN "warehouseStoreId" SET NOT NULL;

-- AddForeignKey
ALTER TABLE "MaterialIssueVoucher" ADD CONSTRAINT "MaterialIssueVoucher_warehouseStoreId_fkey" FOREIGN KEY ("warehouseStoreId") REFERENCES "WarehouseStore"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
