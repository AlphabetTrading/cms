/*
  Warnings:

  - You are about to drop the column `date` on the `PriceHistory` table. All the data in the column will be lost.
  - Added the required column `updatedAt` to the `PriceHistory` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "IssueVoucherItem" ALTER COLUMN "quantity" SET DATA TYPE DOUBLE PRECISION;

-- AlterTable
ALTER TABLE "MaterialReceiveItem" ALTER COLUMN "quantity" SET DATA TYPE DOUBLE PRECISION;

-- AlterTable
ALTER TABLE "MaterialRequestItem" ALTER COLUMN "quantity" SET DATA TYPE DOUBLE PRECISION,
ALTER COLUMN "inStockQuantity" SET DATA TYPE DOUBLE PRECISION,
ALTER COLUMN "toBePurchasedQuantity" SET DATA TYPE DOUBLE PRECISION;

-- AlterTable
ALTER TABLE "PriceHistory" DROP COLUMN "date",
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "PurchaseOrderItem" ALTER COLUMN "quantityRequested" SET DATA TYPE DOUBLE PRECISION;

-- AlterTable
ALTER TABLE "ReturnVoucherItem" ALTER COLUMN "quantityReturned" SET DATA TYPE DOUBLE PRECISION;

-- AlterTable
ALTER TABLE "WarehouseProduct" ALTER COLUMN "quantity" SET DATA TYPE DOUBLE PRECISION;
