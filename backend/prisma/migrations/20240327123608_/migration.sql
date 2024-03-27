/*
  Warnings:

  - You are about to drop the column `date` on the `MaterialIssueVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `date` on the `MaterialReceiveVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `date` on the `MaterialRequestVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `date` on the `MaterialReturnVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `date` on the `PurchaseOrder` table. All the data in the column will be lost.
  - Added the required column `updatedAt` to the `IssueVoucherItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `MaterialReceiveItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `MaterialRequestItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `PurchaseOrderItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `ReturnVoucherItem` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "IssueVoucherItem" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "MaterialIssueVoucher" DROP COLUMN "date";

-- AlterTable
ALTER TABLE "MaterialReceiveItem" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReceiveVoucher" DROP COLUMN "date";

-- AlterTable
ALTER TABLE "MaterialRequestItem" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "MaterialRequestVoucher" DROP COLUMN "date";

-- AlterTable
ALTER TABLE "MaterialReturnVoucher" DROP COLUMN "date";

-- AlterTable
ALTER TABLE "PurchaseOrder" DROP COLUMN "date";

-- AlterTable
ALTER TABLE "PurchaseOrderItem" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "ReturnVoucherItem" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;
