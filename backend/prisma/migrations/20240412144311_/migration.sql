/*
  Warnings:

  - You are about to drop the column `productId` on the `IssueVoucherItem` table. All the data in the column will be lost.
  - You are about to drop the column `productId` on the `MaterialReceiveItem` table. All the data in the column will be lost.
  - You are about to drop the column `productId` on the `MaterialRequestItem` table. All the data in the column will be lost.
  - You are about to drop the column `productId` on the `PurchaseOrderItem` table. All the data in the column will be lost.
  - You are about to drop the column `productId` on the `ReturnVoucherItem` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[id,productUseId]` on the table `IssueVoucherItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,productVariantId]` on the table `MaterialReceiveItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,productVariantId]` on the table `MaterialRequestItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,productVariantId]` on the table `PurchaseOrderItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,productVariantId]` on the table `ReturnVoucherItem` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `productUseId` to the `IssueVoucherItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `productVariantId` to the `MaterialReceiveItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `productVariantId` to the `MaterialRequestItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `productVariantId` to the `PurchaseOrderItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `productVariantId` to the `ReturnVoucherItem` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "IssueVoucherItem" DROP CONSTRAINT "IssueVoucherItem_productId_fkey";

-- DropForeignKey
ALTER TABLE "MaterialReceiveItem" DROP CONSTRAINT "MaterialReceiveItem_productId_fkey";

-- DropForeignKey
ALTER TABLE "MaterialRequestItem" DROP CONSTRAINT "MaterialRequestItem_productId_fkey";

-- DropForeignKey
ALTER TABLE "PurchaseOrderItem" DROP CONSTRAINT "PurchaseOrderItem_productId_fkey";

-- DropForeignKey
ALTER TABLE "ReturnVoucherItem" DROP CONSTRAINT "ReturnVoucherItem_productId_fkey";

-- DropIndex
DROP INDEX "IssueVoucherItem_id_productId_key";

-- DropIndex
DROP INDEX "MaterialReceiveItem_id_productId_key";

-- DropIndex
DROP INDEX "MaterialRequestItem_id_productId_key";

-- DropIndex
DROP INDEX "PurchaseOrderItem_id_productId_key";

-- DropIndex
DROP INDEX "ReturnVoucherItem_id_productId_key";

-- AlterTable
ALTER TABLE "IssueVoucherItem" DROP COLUMN "productId",
ADD COLUMN     "productUseId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReceiveItem" DROP COLUMN "productId",
ADD COLUMN     "productVariantId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "MaterialRequestItem" DROP COLUMN "productId",
ADD COLUMN     "productVariantId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "PurchaseOrderItem" DROP COLUMN "productId",
ADD COLUMN     "productVariantId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "ReturnVoucherItem" DROP COLUMN "productId",
ADD COLUMN     "productVariantId" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "IssueVoucherItem_id_productUseId_key" ON "IssueVoucherItem"("id", "productUseId");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialReceiveItem_id_productVariantId_key" ON "MaterialReceiveItem"("id", "productVariantId");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialRequestItem_id_productVariantId_key" ON "MaterialRequestItem"("id", "productVariantId");

-- CreateIndex
CREATE UNIQUE INDEX "PurchaseOrderItem_id_productVariantId_key" ON "PurchaseOrderItem"("id", "productVariantId");

-- CreateIndex
CREATE UNIQUE INDEX "ReturnVoucherItem_id_productVariantId_key" ON "ReturnVoucherItem"("id", "productVariantId");

-- AddForeignKey
ALTER TABLE "PurchaseOrderItem" ADD CONSTRAINT "PurchaseOrderItem_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReturnVoucherItem" ADD CONSTRAINT "ReturnVoucherItem_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IssueVoucherItem" ADD CONSTRAINT "IssueVoucherItem_productUseId_fkey" FOREIGN KEY ("productUseId") REFERENCES "ProductUse"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveItem" ADD CONSTRAINT "MaterialReceiveItem_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialRequestItem" ADD CONSTRAINT "MaterialRequestItem_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
