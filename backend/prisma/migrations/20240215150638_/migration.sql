/*
  Warnings:

  - You are about to drop the column `subtotal` on the `PurchaseOrder` table. All the data in the column will be lost.
  - Added the required column `subTotal` to the `PurchaseOrder` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "PurchaseOrder" DROP COLUMN "subtotal",
ADD COLUMN     "subTotal" DOUBLE PRECISION NOT NULL;
