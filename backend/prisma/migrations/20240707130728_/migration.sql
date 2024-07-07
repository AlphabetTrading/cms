/*
  Warnings:

  - You are about to drop the column `projectId` on the `PriceHistory` table. All the data in the column will be lost.
  - Added the required column `companyId` to the `PriceHistory` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "PriceHistory" DROP CONSTRAINT "PriceHistory_projectId_fkey";

-- DropIndex
DROP INDEX "PriceHistory_productVariantId_projectId_idx";

-- AlterTable
ALTER TABLE "PriceHistory" DROP COLUMN "projectId",
ADD COLUMN     "companyId" TEXT NOT NULL;

-- CreateIndex
CREATE INDEX "PriceHistory_productVariantId_companyId_idx" ON "PriceHistory"("productVariantId", "companyId");

-- AddForeignKey
ALTER TABLE "PriceHistory" ADD CONSTRAINT "PriceHistory_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
