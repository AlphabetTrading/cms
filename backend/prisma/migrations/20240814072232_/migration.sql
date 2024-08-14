/*
  Warnings:

  - You are about to drop the column `productVariantId` on the `MaterialReceiveItem` table. All the data in the column will be lost.
  - You are about to drop the column `quantity` on the `MaterialReceiveItem` table. All the data in the column will be lost.
  - You are about to drop the column `totalCost` on the `MaterialReceiveItem` table. All the data in the column will be lost.
  - You are about to drop the column `unitCost` on the `MaterialReceiveItem` table. All the data in the column will be lost.
  - You are about to drop the column `purchaseOrderId` on the `MaterialReceiveVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `purchasedById` on the `MaterialReceiveVoucher` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[id,purchaseOrderItemId]` on the table `MaterialReceiveItem` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `purchaseOrderItemId` to the `MaterialReceiveItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `receivedQuantity` to the `MaterialReceiveItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `preparedById` to the `MaterialReceiveVoucher` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "MaterialReceiveItem" DROP CONSTRAINT "MaterialReceiveItem_productVariantId_fkey";

-- DropForeignKey
ALTER TABLE "MaterialReceiveVoucher" DROP CONSTRAINT "MaterialReceiveVoucher_purchaseOrderId_fkey";

-- DropForeignKey
ALTER TABLE "MaterialReceiveVoucher" DROP CONSTRAINT "MaterialReceiveVoucher_purchasedById_fkey";

-- DropIndex
DROP INDEX "MaterialReceiveItem_id_productVariantId_key";

-- AlterTable
ALTER TABLE "MaterialReceiveItem" DROP COLUMN "productVariantId",
DROP COLUMN "quantity",
DROP COLUMN "totalCost",
DROP COLUMN "unitCost",
ADD COLUMN     "purchaseOrderItemId" TEXT NOT NULL,
ADD COLUMN     "receivedQuantity" DOUBLE PRECISION NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReceiveVoucher" DROP COLUMN "purchaseOrderId",
DROP COLUMN "purchasedById",
ADD COLUMN     "preparedById" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "MaterialReceiveItem_id_purchaseOrderItemId_key" ON "MaterialReceiveItem"("id", "purchaseOrderItemId");

-- AddForeignKey
ALTER TABLE "MaterialReceiveVoucher" ADD CONSTRAINT "MaterialReceiveVoucher_preparedById_fkey" FOREIGN KEY ("preparedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveItem" ADD CONSTRAINT "MaterialReceiveItem_purchaseOrderItemId_fkey" FOREIGN KEY ("purchaseOrderItemId") REFERENCES "PurchaseOrderItem"("id") ON DELETE CASCADE ON UPDATE CASCADE;
