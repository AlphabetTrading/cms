/*
  Warnings:

  - You are about to drop the column `unitOfMeasure` on the `IssueVoucherItem` table. All the data in the column will be lost.
  - You are about to drop the column `unitOfMeasure` on the `MaterialReceiveItem` table. All the data in the column will be lost.
  - You are about to drop the column `unitOfMeasure` on the `MaterialRequestItem` table. All the data in the column will be lost.
  - You are about to drop the column `unitOfMeasure` on the `PurchaseOrderItem` table. All the data in the column will be lost.
  - You are about to drop the column `unitOfMeasure` on the `ReturnVoucherItem` table. All the data in the column will be lost.
  - Added the required column `unitOfMeasure` to the `ProductVariant` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "UnitOfMeasure" AS ENUM ('KG', 'BERGA', 'QUINTAL', 'M2', 'M3', 'LITER', 'PCS');

-- AlterTable
ALTER TABLE "IssueVoucherItem" DROP COLUMN "unitOfMeasure";

-- AlterTable
ALTER TABLE "MaterialReceiveItem" DROP COLUMN "unitOfMeasure";

-- AlterTable
ALTER TABLE "MaterialRequestItem" DROP COLUMN "unitOfMeasure";

-- AlterTable
ALTER TABLE "ProductVariant" ADD COLUMN     "unitOfMeasure" "UnitOfMeasure" NOT NULL;

-- AlterTable
ALTER TABLE "PurchaseOrderItem" DROP COLUMN "unitOfMeasure";

-- AlterTable
ALTER TABLE "ReturnVoucherItem" DROP COLUMN "unitOfMeasure";
