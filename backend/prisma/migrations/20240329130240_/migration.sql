/*
  Warnings:

  - You are about to drop the column `listNo` on the `IssueVoucherItem` table. All the data in the column will be lost.
  - You are about to drop the column `listNo` on the `MaterialReceiveItem` table. All the data in the column will be lost.
  - You are about to drop the column `inStockQuantity` on the `MaterialRequestItem` table. All the data in the column will be lost.
  - You are about to drop the column `listNo` on the `MaterialRequestItem` table. All the data in the column will be lost.
  - You are about to drop the column `toBePurchasedQuantity` on the `MaterialRequestItem` table. All the data in the column will be lost.
  - You are about to drop the column `from` on the `MaterialRequestVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `to` on the `MaterialRequestVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `listNo` on the `PurchaseOrderItem` table. All the data in the column will be lost.
  - You are about to drop the column `listNo` on the `ReturnVoucherItem` table. All the data in the column will be lost.
  - You are about to drop the column `quantityReturned` on the `ReturnVoucherItem` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[description]` on the table `IssueVoucherItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,description]` on the table `IssueVoucherItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[description]` on the table `MaterialReceiveItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,description]` on the table `MaterialReceiveItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[description]` on the table `MaterialRequestItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,description]` on the table `MaterialRequestItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[description]` on the table `PurchaseOrderItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,description]` on the table `PurchaseOrderItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[description]` on the table `ReturnVoucherItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,description]` on the table `ReturnVoucherItem` will be added. If there are existing duplicate values, this will fail.
  - Made the column `description` on table `IssueVoucherItem` required. This step will fail if there are existing NULL values in that column.
  - Made the column `description` on table `MaterialReceiveItem` required. This step will fail if there are existing NULL values in that column.
  - Made the column `description` on table `MaterialRequestItem` required. This step will fail if there are existing NULL values in that column.
  - Made the column `description` on table `PurchaseOrderItem` required. This step will fail if there are existing NULL values in that column.
  - Added the required column `quantity` to the `ReturnVoucherItem` table without a default value. This is not possible if the table is not empty.
  - Made the column `description` on table `ReturnVoucherItem` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "IssueVoucherItem" DROP CONSTRAINT "IssueVoucherItem_materialIssueVoucherId_fkey";

-- DropForeignKey
ALTER TABLE "MaterialReceiveItem" DROP CONSTRAINT "MaterialReceiveItem_materialReceiveVoucherId_fkey";

-- DropForeignKey
ALTER TABLE "MaterialRequestItem" DROP CONSTRAINT "MaterialRequestItem_materialRequestVoucherId_fkey";

-- DropForeignKey
ALTER TABLE "ReturnVoucherItem" DROP CONSTRAINT "ReturnVoucherItem_materialReturnVoucherId_fkey";

-- DropIndex
DROP INDEX "IssueVoucherItem_id_listNo_key";

-- DropIndex
DROP INDEX "MaterialReceiveItem_id_listNo_key";

-- DropIndex
DROP INDEX "MaterialRequestItem_id_listNo_key";

-- DropIndex
DROP INDEX "PurchaseOrderItem_id_listNo_key";

-- DropIndex
DROP INDEX "ReturnVoucherItem_id_listNo_key";

-- AlterTable
ALTER TABLE "IssueVoucherItem" DROP COLUMN "listNo",
ALTER COLUMN "description" SET NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReceiveItem" DROP COLUMN "listNo",
ALTER COLUMN "description" SET NOT NULL;

-- AlterTable
ALTER TABLE "MaterialRequestItem" DROP COLUMN "inStockQuantity",
DROP COLUMN "listNo",
DROP COLUMN "toBePurchasedQuantity",
ALTER COLUMN "description" SET NOT NULL;

-- AlterTable
ALTER TABLE "MaterialRequestVoucher" DROP COLUMN "from",
DROP COLUMN "to";

-- AlterTable
ALTER TABLE "PurchaseOrderItem" DROP COLUMN "listNo",
ALTER COLUMN "description" SET NOT NULL;

-- AlterTable
ALTER TABLE "ReturnVoucherItem" DROP COLUMN "listNo",
DROP COLUMN "quantityReturned",
ADD COLUMN     "quantity" DOUBLE PRECISION NOT NULL,
ALTER COLUMN "description" SET NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "IssueVoucherItem_description_key" ON "IssueVoucherItem"("description");

-- CreateIndex
CREATE UNIQUE INDEX "IssueVoucherItem_id_description_key" ON "IssueVoucherItem"("id", "description");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialReceiveItem_description_key" ON "MaterialReceiveItem"("description");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialReceiveItem_id_description_key" ON "MaterialReceiveItem"("id", "description");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialRequestItem_description_key" ON "MaterialRequestItem"("description");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialRequestItem_id_description_key" ON "MaterialRequestItem"("id", "description");

-- CreateIndex
CREATE UNIQUE INDEX "PurchaseOrderItem_description_key" ON "PurchaseOrderItem"("description");

-- CreateIndex
CREATE UNIQUE INDEX "PurchaseOrderItem_id_description_key" ON "PurchaseOrderItem"("id", "description");

-- CreateIndex
CREATE UNIQUE INDEX "ReturnVoucherItem_description_key" ON "ReturnVoucherItem"("description");

-- CreateIndex
CREATE UNIQUE INDEX "ReturnVoucherItem_id_description_key" ON "ReturnVoucherItem"("id", "description");

-- AddForeignKey
ALTER TABLE "ReturnVoucherItem" ADD CONSTRAINT "ReturnVoucherItem_materialReturnVoucherId_fkey" FOREIGN KEY ("materialReturnVoucherId") REFERENCES "MaterialReturnVoucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IssueVoucherItem" ADD CONSTRAINT "IssueVoucherItem_materialIssueVoucherId_fkey" FOREIGN KEY ("materialIssueVoucherId") REFERENCES "MaterialIssueVoucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveItem" ADD CONSTRAINT "MaterialReceiveItem_materialReceiveVoucherId_fkey" FOREIGN KEY ("materialReceiveVoucherId") REFERENCES "MaterialReceiveVoucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialRequestItem" ADD CONSTRAINT "MaterialRequestItem_materialRequestVoucherId_fkey" FOREIGN KEY ("materialRequestVoucherId") REFERENCES "MaterialRequestVoucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;
