/*
  Warnings:

  - You are about to drop the column `productUseId` on the `IssueVoucherItem` table. All the data in the column will be lost.
  - You are about to drop the `ProductUse` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[id,productVariantId]` on the table `IssueVoucherItem` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `productVariantId` to the `IssueVoucherItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `useType` to the `IssueVoucherItem` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "IssueVoucherItem" DROP CONSTRAINT "IssueVoucherItem_productUseId_fkey";

-- DropForeignKey
ALTER TABLE "ProductUse" DROP CONSTRAINT "ProductUse_productVariantId_fkey";

-- DropIndex
DROP INDEX "IssueVoucherItem_id_productUseId_key";

-- AlterTable
ALTER TABLE "IssueVoucherItem" DROP COLUMN "productUseId",
ADD COLUMN     "productVariantId" TEXT NOT NULL,
ADD COLUMN     "subStructureDescription" "SubStructureUseDescription",
ADD COLUMN     "superStructureDescription" "SuperStructureUseDescription",
ADD COLUMN     "useType" "UseType" NOT NULL;

-- DropTable
DROP TABLE "ProductUse";

-- CreateIndex
CREATE UNIQUE INDEX "IssueVoucherItem_id_productVariantId_key" ON "IssueVoucherItem"("id", "productVariantId");

-- AddForeignKey
ALTER TABLE "IssueVoucherItem" ADD CONSTRAINT "IssueVoucherItem_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
