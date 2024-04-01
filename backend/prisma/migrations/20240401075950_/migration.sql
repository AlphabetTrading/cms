/*
  Warnings:

  - You are about to drop the column `quantityRequested` on the `PurchaseOrderItem` table. All the data in the column will be lost.
  - Added the required column `quantity` to the `PurchaseOrderItem` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "PurchaseOrderItem" DROP COLUMN "quantityRequested",
ADD COLUMN     "quantity" DOUBLE PRECISION NOT NULL;
