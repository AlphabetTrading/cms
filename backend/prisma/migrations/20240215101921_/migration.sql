/*
  Warnings:

  - A unique constraint covering the columns `[id,listNo]` on the table `IssueVoucherItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,listNo]` on the table `MaterialReceiveItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,listNo]` on the table `MaterialRequestItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,listNo]` on the table `PurchaseOrderItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,listNo]` on the table `ReturnVoucherItem` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "IssueVoucherItem_listNo_key";

-- DropIndex
DROP INDEX "MaterialReceiveItem_listNo_key";

-- DropIndex
DROP INDEX "MaterialRequestItem_listNo_key";

-- DropIndex
DROP INDEX "PurchaseOrderItem_listNo_key";

-- DropIndex
DROP INDEX "ReturnVoucherItem_listNo_key";

-- CreateIndex
CREATE UNIQUE INDEX "IssueVoucherItem_id_listNo_key" ON "IssueVoucherItem"("id", "listNo");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialReceiveItem_id_listNo_key" ON "MaterialReceiveItem"("id", "listNo");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialRequestItem_id_listNo_key" ON "MaterialRequestItem"("id", "listNo");

-- CreateIndex
CREATE UNIQUE INDEX "PurchaseOrderItem_id_listNo_key" ON "PurchaseOrderItem"("id", "listNo");

-- CreateIndex
CREATE UNIQUE INDEX "ReturnVoucherItem_id_listNo_key" ON "ReturnVoucherItem"("id", "listNo");
