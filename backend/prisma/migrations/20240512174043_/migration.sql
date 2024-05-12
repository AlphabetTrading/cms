/*
  Warnings:

  - Made the column `materialReceiveId` on table `MaterialTransferVoucher` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "MaterialTransferVoucher" ALTER COLUMN "materialReceiveId" SET NOT NULL;

-- AddForeignKey
ALTER TABLE "MaterialTransferVoucher" ADD CONSTRAINT "MaterialTransferVoucher_materialReceiveId_fkey" FOREIGN KEY ("materialReceiveId") REFERENCES "MaterialReceiveVoucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;
