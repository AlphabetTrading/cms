/*
  Warnings:

  - You are about to drop the column `description` on the `Product` table. All the data in the column will be lost.
  - Added the required column `ProductType` to the `Product` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "ProductType" AS ENUM ('CONSTRUCTION', 'SANITARY', 'ELECTRICAL');

-- CreateEnum
CREATE TYPE "UseType" AS ENUM ('SUB_STRUCTURE', 'SUPER_STRUCTURE');

-- CreateEnum
CREATE TYPE "SubStructureUseDescription" AS ENUM ('EXCAVATION_AND_EARTH_WORK', 'CONCRETE_WORK', 'MASONRY_WORK');

-- CreateEnum
CREATE TYPE "SuperStructureUseDescription" AS ENUM ('CONCRETE_WORK', 'BLOCK_WORK', 'ROOFING', 'CARPENTRY_AND_JOINERY', 'METAL_WORK', 'PLASTERING_WORK', 'FINISHING_WORK', 'PAINTING_WORK', 'SANITARY_INSTALLATION', 'ELECTRICAL_INSTALLATION', 'MECHANICAL_INSTALLATION');

-- DropForeignKey
ALTER TABLE "IssueVoucherItem" DROP CONSTRAINT "IssueVoucherItem_productId_fkey";

-- DropForeignKey
ALTER TABLE "MaterialReceiveItem" DROP CONSTRAINT "MaterialReceiveItem_productId_fkey";

-- DropForeignKey
ALTER TABLE "MaterialRequestItem" DROP CONSTRAINT "MaterialRequestItem_productId_fkey";

-- DropForeignKey
ALTER TABLE "PriceHistory" DROP CONSTRAINT "PriceHistory_productId_fkey";

-- DropForeignKey
ALTER TABLE "PurchaseOrderItem" DROP CONSTRAINT "PurchaseOrderItem_productId_fkey";

-- DropForeignKey
ALTER TABLE "ReturnVoucherItem" DROP CONSTRAINT "ReturnVoucherItem_productId_fkey";

-- DropForeignKey
ALTER TABLE "WarehouseProduct" DROP CONSTRAINT "WarehouseProduct_productId_fkey";

-- AlterTable
ALTER TABLE "Product" DROP COLUMN "description",
ADD COLUMN     "ProductType" "ProductType" NOT NULL;

-- CreateTable
CREATE TABLE "ProductVariant" (
    "id" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "variant" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductVariant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductUse" (
    "id" TEXT NOT NULL,
    "productVariantId" TEXT NOT NULL,
    "useType" "UseType" NOT NULL,
    "subStructureDescription" "SubStructureUseDescription",
    "superStructureDescription" "SuperStructureUseDescription",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductUse_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "ProductVariant_productId_variant_key" ON "ProductVariant"("productId", "variant");

-- AddForeignKey
ALTER TABLE "ProductVariant" ADD CONSTRAINT "ProductVariant_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductUse" ADD CONSTRAINT "ProductUse_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WarehouseProduct" ADD CONSTRAINT "WarehouseProduct_productId_fkey" FOREIGN KEY ("productId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PriceHistory" ADD CONSTRAINT "PriceHistory_productId_fkey" FOREIGN KEY ("productId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrderItem" ADD CONSTRAINT "PurchaseOrderItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReturnVoucherItem" ADD CONSTRAINT "ReturnVoucherItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IssueVoucherItem" ADD CONSTRAINT "IssueVoucherItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "ProductUse"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveItem" ADD CONSTRAINT "MaterialReceiveItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialRequestItem" ADD CONSTRAINT "MaterialRequestItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
