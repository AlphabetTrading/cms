/*
  Warnings:

  - A unique constraint covering the columns `[listNo]` on the table `IssueVoucherItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[listNo]` on the table `MaterialReceiveItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[listNo]` on the table `MaterialRequestItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[listNo]` on the table `PurchaseOrderItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[listNo]` on the table `ReturnVoucherItem` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `listNo` to the `IssueVoucherItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `listNo` to the `MaterialReceiveItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `listNo` to the `MaterialRequestItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `listNo` to the `PurchaseOrderItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `listNo` to the `ReturnVoucherItem` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "IssueVoucherItem" ADD COLUMN     "listNo" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReceiveItem" ADD COLUMN     "listNo" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReceiveVoucher" ALTER COLUMN "invoiceId" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "MaterialRequestItem" ADD COLUMN     "listNo" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "PurchaseOrderItem" ADD COLUMN     "listNo" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "ReturnVoucherItem" ADD COLUMN     "listNo" INTEGER NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "IssueVoucherItem_listNo_key" ON "IssueVoucherItem"("listNo");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialReceiveItem_listNo_key" ON "MaterialReceiveItem"("listNo");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialRequestItem_listNo_key" ON "MaterialRequestItem"("listNo");

-- CreateIndex
CREATE UNIQUE INDEX "PurchaseOrderItem_listNo_key" ON "PurchaseOrderItem"("listNo");

-- CreateIndex
CREATE UNIQUE INDEX "ReturnVoucherItem_listNo_key" ON "ReturnVoucherItem"("listNo");
