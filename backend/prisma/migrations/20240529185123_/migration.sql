/*
  Warnings:

  - You are about to drop the column `receivingStore` on the `MaterialReturnVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `receivingStore` on the `MaterialTransferVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `sendingStore` on the `MaterialTransferVoucher` table. All the data in the column will be lost.
  - Added the required column `receivingWarehouseStoreId` to the `MaterialReturnVoucher` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "MaterialReturnVoucher" DROP COLUMN "receivingStore",
ADD COLUMN     "receivingWarehouseStoreId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "MaterialTransferVoucher" DROP COLUMN "receivingStore",
DROP COLUMN "sendingStore",
ADD COLUMN     "receivingWarehouseStoreId" TEXT,
ADD COLUMN     "sendingWarehouseStoreId" TEXT;

-- AddForeignKey
ALTER TABLE "MaterialReturnVoucher" ADD CONSTRAINT "MaterialReturnVoucher_receivingWarehouseStoreId_fkey" FOREIGN KEY ("receivingWarehouseStoreId") REFERENCES "WarehouseStore"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialTransferVoucher" ADD CONSTRAINT "MaterialTransferVoucher_sendingWarehouseStoreId_fkey" FOREIGN KEY ("sendingWarehouseStoreId") REFERENCES "WarehouseStore"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialTransferVoucher" ADD CONSTRAINT "MaterialTransferVoucher_receivingWarehouseStoreId_fkey" FOREIGN KEY ("receivingWarehouseStoreId") REFERENCES "WarehouseStore"("id") ON DELETE SET NULL ON UPDATE CASCADE;
