/*
  Warnings:

  - A unique constraint covering the columns `[serialNumber]` on the table `MaterialIssueVoucher` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[serialNumber]` on the table `MaterialReceiveVoucher` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[serialNumber]` on the table `MaterialRequestVoucher` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[serialNumber]` on the table `MaterialReturnVoucher` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[serialNumber]` on the table `PurchaseOrder` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `serialNumber` to the `MaterialIssueVoucher` table without a default value. This is not possible if the table is not empty.
  - Added the required column `serialNumber` to the `MaterialReceiveVoucher` table without a default value. This is not possible if the table is not empty.
  - Added the required column `serialNumber` to the `MaterialRequestVoucher` table without a default value. This is not possible if the table is not empty.
  - Added the required column `serialNumber` to the `MaterialReturnVoucher` table without a default value. This is not possible if the table is not empty.
  - Added the required column `serialNumber` to the `PurchaseOrder` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "MaterialIssueVoucher" ADD COLUMN     "serialNumber" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReceiveVoucher" ADD COLUMN     "serialNumber" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "MaterialRequestVoucher" ADD COLUMN     "serialNumber" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReturnVoucher" ADD COLUMN     "serialNumber" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "PurchaseOrder" ADD COLUMN     "serialNumber" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "MaterialIssueVoucher_serialNumber_key" ON "MaterialIssueVoucher"("serialNumber");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialReceiveVoucher_serialNumber_key" ON "MaterialReceiveVoucher"("serialNumber");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialRequestVoucher_serialNumber_key" ON "MaterialRequestVoucher"("serialNumber");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialReturnVoucher_serialNumber_key" ON "MaterialReturnVoucher"("serialNumber");

-- CreateIndex
CREATE UNIQUE INDEX "PurchaseOrder_serialNumber_key" ON "PurchaseOrder"("serialNumber");
