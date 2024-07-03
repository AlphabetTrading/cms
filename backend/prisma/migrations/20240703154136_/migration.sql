/*
  Warnings:

  - You are about to drop the column `invoiceId` on the `MaterialReceiveVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `materialRequestId` on the `MaterialReceiveVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `supplierName` on the `MaterialReceiveVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `description` on the `Proforma` table. All the data in the column will be lost.
  - You are about to drop the column `materialRequestId` on the `Proforma` table. All the data in the column will be lost.
  - You are about to drop the column `photos` on the `Proforma` table. All the data in the column will be lost.
  - You are about to drop the column `materialRequestId` on the `PurchaseOrder` table. All the data in the column will be lost.
  - You are about to drop the column `supplierName` on the `PurchaseOrder` table. All the data in the column will be lost.
  - You are about to drop the column `productVariantId` on the `PurchaseOrderItem` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[id,proformaId,materialRequestItemId]` on the table `PurchaseOrderItem` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `materialRequestItemId` to the `Proforma` table without a default value. This is not possible if the table is not empty.
  - Added the required column `photo` to the `Proforma` table without a default value. This is not possible if the table is not empty.
  - Added the required column `preparedById` to the `Proforma` table without a default value. This is not possible if the table is not empty.
  - Added the required column `quantity` to the `Proforma` table without a default value. This is not possible if the table is not empty.
  - Added the required column `totalPrice` to the `Proforma` table without a default value. This is not possible if the table is not empty.
  - Added the required column `unitPrice` to the `Proforma` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "MaterialReceiveVoucher" DROP CONSTRAINT "MaterialReceiveVoucher_materialRequestId_fkey";

-- DropForeignKey
ALTER TABLE "Proforma" DROP CONSTRAINT "Proforma_materialRequestId_fkey";

-- DropForeignKey
ALTER TABLE "PurchaseOrder" DROP CONSTRAINT "PurchaseOrder_materialRequestId_fkey";

-- DropForeignKey
ALTER TABLE "PurchaseOrderItem" DROP CONSTRAINT "PurchaseOrderItem_productVariantId_fkey";

-- DropIndex
DROP INDEX "PurchaseOrderItem_id_productVariantId_key";

-- AlterTable
ALTER TABLE "MaterialReceiveVoucher" DROP COLUMN "invoiceId",
DROP COLUMN "materialRequestId",
DROP COLUMN "supplierName";

-- AlterTable
ALTER TABLE "Proforma" DROP COLUMN "description",
DROP COLUMN "materialRequestId",
DROP COLUMN "photos",
ADD COLUMN     "approvedById" TEXT,
ADD COLUMN     "materialRequestItemId" TEXT NOT NULL,
ADD COLUMN     "photo" TEXT NOT NULL,
ADD COLUMN     "preparedById" TEXT NOT NULL,
ADD COLUMN     "quantity" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "remark" TEXT,
ADD COLUMN     "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING',
ADD COLUMN     "totalPrice" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "unitPrice" DOUBLE PRECISION NOT NULL;

-- AlterTable
ALTER TABLE "PurchaseOrder" DROP COLUMN "materialRequestId",
DROP COLUMN "supplierName";

-- AlterTable
ALTER TABLE "PurchaseOrderItem" DROP COLUMN "productVariantId",
ADD COLUMN     "materialRequestItemId" TEXT,
ADD COLUMN     "proformaId" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "PurchaseOrderItem_id_proformaId_materialRequestItemId_key" ON "PurchaseOrderItem"("id", "proformaId", "materialRequestItemId");

-- AddForeignKey
ALTER TABLE "Proforma" ADD CONSTRAINT "Proforma_preparedById_fkey" FOREIGN KEY ("preparedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Proforma" ADD CONSTRAINT "Proforma_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Proforma" ADD CONSTRAINT "Proforma_materialRequestItemId_fkey" FOREIGN KEY ("materialRequestItemId") REFERENCES "MaterialRequestItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrderItem" ADD CONSTRAINT "PurchaseOrderItem_proformaId_fkey" FOREIGN KEY ("proformaId") REFERENCES "Proforma"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrderItem" ADD CONSTRAINT "PurchaseOrderItem_materialRequestItemId_fkey" FOREIGN KEY ("materialRequestItemId") REFERENCES "MaterialRequestItem"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddCheck
ALTER TABLE "PurchaseOrderItem" ADD CONSTRAINT "proforma_or_material_request_item" CHECK ("proformaId" IS NULL OR "materialRequestItemId" IS NULL);