-- AlterTable
ALTER TABLE "MaterialIssueVoucher" ADD COLUMN     "warehouseStoreId" TEXT;

-- AddForeignKey
ALTER TABLE "MaterialIssueVoucher" ADD CONSTRAINT "MaterialIssueVoucher_warehouseStoreId_fkey" FOREIGN KEY ("warehouseStoreId") REFERENCES "WarehouseStore"("id") ON DELETE SET NULL ON UPDATE CASCADE;
