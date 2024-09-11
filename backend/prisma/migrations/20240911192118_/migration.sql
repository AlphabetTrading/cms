-- DropForeignKey
ALTER TABLE "MaterialTransferItem" DROP CONSTRAINT "MaterialTransferItem_materialTransferVoucherId_fkey";

-- DropForeignKey
ALTER TABLE "ProformaItem" DROP CONSTRAINT "ProformaItem_proformaId_fkey";

-- DropForeignKey
ALTER TABLE "PurchaseOrderItem" DROP CONSTRAINT "PurchaseOrderItem_purchaseOrderId_fkey";

-- AddForeignKey
ALTER TABLE "ProformaItem" ADD CONSTRAINT "ProformaItem_proformaId_fkey" FOREIGN KEY ("proformaId") REFERENCES "Proforma"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrderItem" ADD CONSTRAINT "PurchaseOrderItem_purchaseOrderId_fkey" FOREIGN KEY ("purchaseOrderId") REFERENCES "PurchaseOrder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialTransferItem" ADD CONSTRAINT "MaterialTransferItem_materialTransferVoucherId_fkey" FOREIGN KEY ("materialTransferVoucherId") REFERENCES "MaterialTransferVoucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;
