-- DropForeignKey
ALTER TABLE "MaterialIssueVoucher" DROP CONSTRAINT "MaterialIssueVoucher_receivedById_fkey";

-- DropForeignKey
ALTER TABLE "MaterialReceiveVoucher" DROP CONSTRAINT "MaterialReceiveVoucher_receivedById_fkey";

-- AlterTable
ALTER TABLE "MaterialIssueVoucher" ALTER COLUMN "receivedById" DROP NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReceiveItem" ALTER COLUMN "description" DROP NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReceiveVoucher" ALTER COLUMN "projectDetails" DROP NOT NULL,
ALTER COLUMN "receivedById" DROP NOT NULL;

-- AlterTable
ALTER TABLE "MaterialRequestItem" ALTER COLUMN "description" DROP NOT NULL;

-- AlterTable
ALTER TABLE "PurchaseOrder" ALTER COLUMN "dateOfReceiving" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "MaterialIssueVoucher" ADD CONSTRAINT "MaterialIssueVoucher_receivedById_fkey" FOREIGN KEY ("receivedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveVoucher" ADD CONSTRAINT "MaterialReceiveVoucher_receivedById_fkey" FOREIGN KEY ("receivedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
