/*
  Warnings:

  - You are about to drop the column `preparerById` on the `PurchaseOrder` table. All the data in the column will be lost.
  - Added the required column `preparedById` to the `PurchaseOrder` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "PurchaseOrder" DROP CONSTRAINT "PurchaseOrder_preparerById_fkey";

-- AlterTable
ALTER TABLE "PurchaseOrder" DROP COLUMN "preparerById",
ADD COLUMN     "preparedById" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "PurchaseOrder" ADD CONSTRAINT "PurchaseOrder_preparedById_fkey" FOREIGN KEY ("preparedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
