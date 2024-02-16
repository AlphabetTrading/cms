/*
  Warnings:

  - You are about to drop the column `receivedById` on the `MaterialIssueVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `receivedById` on the `MaterialReceiveVoucher` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "MaterialIssueVoucher" DROP CONSTRAINT "MaterialIssueVoucher_receivedById_fkey";

-- DropForeignKey
ALTER TABLE "MaterialReceiveVoucher" DROP CONSTRAINT "MaterialReceiveVoucher_receivedById_fkey";

-- AlterTable
ALTER TABLE "MaterialIssueVoucher" DROP COLUMN "receivedById";

-- AlterTable
ALTER TABLE "MaterialReceiveVoucher" DROP COLUMN "receivedById";
