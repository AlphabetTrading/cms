-- AlterTable
ALTER TABLE "MaterialIssueVoucher" ADD COLUMN     "approved" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "MaterialReceiveVoucher" ADD COLUMN     "approved" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "MaterialRequestVoucher" ADD COLUMN     "approved" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "MaterialReturnVoucher" ADD COLUMN     "received" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "PurchaseOrder" ADD COLUMN     "approved" BOOLEAN NOT NULL DEFAULT false;
