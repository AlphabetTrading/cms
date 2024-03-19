/*
  Warnings:

  - You are about to drop the column `approved` on the `MaterialIssueVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `approved` on the `MaterialReceiveVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `approved` on the `MaterialRequestVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `received` on the `MaterialReturnVoucher` table. All the data in the column will be lost.

*/
-- CreateEnum
CREATE TYPE "ApprovalStatus" AS ENUM ('PENDING', 'COMPLETED', 'DECLINED');

-- AlterTable
ALTER TABLE "MaterialIssueVoucher" DROP COLUMN "approved",
ADD COLUMN     "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "MaterialReceiveVoucher" DROP COLUMN "approved",
ADD COLUMN     "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "MaterialRequestVoucher" DROP COLUMN "approved",
ADD COLUMN     "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "MaterialReturnVoucher" DROP COLUMN "received",
ADD COLUMN     "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "PurchaseOrder" ADD COLUMN     "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING';
