/*
  Warnings:

  - You are about to drop the column `photo` on the `Proforma` table. All the data in the column will be lost.
  - You are about to drop the column `quantity` on the `Proforma` table. All the data in the column will be lost.
  - You are about to drop the column `remark` on the `Proforma` table. All the data in the column will be lost.
  - You are about to drop the column `totalPrice` on the `Proforma` table. All the data in the column will be lost.
  - You are about to drop the column `unitPrice` on the `Proforma` table. All the data in the column will be lost.
  - You are about to drop the column `vendor` on the `Proforma` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[selectedProformaItemId]` on the table `Proforma` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Proforma" DROP COLUMN "photo",
DROP COLUMN "quantity",
DROP COLUMN "remark",
DROP COLUMN "totalPrice",
DROP COLUMN "unitPrice",
DROP COLUMN "vendor",
ADD COLUMN     "selectedProformaItemId" TEXT;

-- CreateTable
CREATE TABLE "ProformaItem" (
    "id" TEXT NOT NULL,
    "vendor" TEXT NOT NULL,
    "quantity" DOUBLE PRECISION NOT NULL,
    "unitPrice" DOUBLE PRECISION NOT NULL,
    "totalPrice" DOUBLE PRECISION NOT NULL,
    "remark" TEXT,
    "photo" TEXT NOT NULL,
    "proformaId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProformaItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "ProformaItem_id_vendor_key" ON "ProformaItem"("id", "vendor");

-- CreateIndex
CREATE UNIQUE INDEX "Proforma_selectedProformaItemId_key" ON "Proforma"("selectedProformaItemId");

-- AddForeignKey
ALTER TABLE "Proforma" ADD CONSTRAINT "Proforma_selectedProformaItemId_fkey" FOREIGN KEY ("selectedProformaItemId") REFERENCES "ProformaItem"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProformaItem" ADD CONSTRAINT "ProformaItem_proformaId_fkey" FOREIGN KEY ("proformaId") REFERENCES "Proforma"("id") ON DELETE SET NULL ON UPDATE CASCADE;
