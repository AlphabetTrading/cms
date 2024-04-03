/*
  Warnings:

  - You are about to drop the column `description` on the `IssueVoucherItem` table. All the data in the column will be lost.
  - You are about to drop the column `issuedToId` on the `MaterialIssueVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `projectDetails` on the `MaterialIssueVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `MaterialIssueVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `description` on the `MaterialReceiveItem` table. All the data in the column will be lost.
  - You are about to drop the column `projectDetails` on the `MaterialReceiveVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `description` on the `MaterialRequestItem` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `MaterialReturnVoucher` table. All the data in the column will be lost.
  - You are about to drop the column `projectManagerId` on the `Project` table. All the data in the column will be lost.
  - You are about to drop the column `dateOfReceiving` on the `PurchaseOrder` table. All the data in the column will be lost.
  - You are about to drop the column `projectDetails` on the `PurchaseOrder` table. All the data in the column will be lost.
  - You are about to drop the column `description` on the `PurchaseOrderItem` table. All the data in the column will be lost.
  - You are about to drop the column `description` on the `ReturnVoucherItem` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[id,productId]` on the table `IssueVoucherItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,productId]` on the table `MaterialReceiveItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,productId]` on the table `MaterialRequestItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,productId]` on the table `PurchaseOrderItem` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,productId]` on the table `ReturnVoucherItem` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `productId` to the `IssueVoucherItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `projectId` to the `MaterialIssueVoucher` table without a default value. This is not possible if the table is not empty.
  - Added the required column `productId` to the `MaterialReceiveItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `projectId` to the `MaterialReceiveVoucher` table without a default value. This is not possible if the table is not empty.
  - Added the required column `productId` to the `MaterialRequestItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `projectId` to the `MaterialRequestVoucher` table without a default value. This is not possible if the table is not empty.
  - Added the required column `projectId` to the `MaterialReturnVoucher` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `Product` table without a default value. This is not possible if the table is not empty.
  - Added the required column `projectId` to the `PurchaseOrder` table without a default value. This is not possible if the table is not empty.
  - Added the required column `productId` to the `PurchaseOrderItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `productId` to the `ReturnVoucherItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `WarehouseProduct` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `WarehouseStore` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "MaterialIssueVoucher" DROP CONSTRAINT "MaterialIssueVoucher_approvedById_fkey";

-- DropForeignKey
ALTER TABLE "MaterialIssueVoucher" DROP CONSTRAINT "MaterialIssueVoucher_issuedToId_fkey";

-- DropForeignKey
ALTER TABLE "MaterialIssueVoucher" DROP CONSTRAINT "MaterialIssueVoucher_userId_fkey";

-- DropForeignKey
ALTER TABLE "MaterialReceiveVoucher" DROP CONSTRAINT "MaterialReceiveVoucher_approvedById_fkey";

-- DropForeignKey
ALTER TABLE "MaterialRequestVoucher" DROP CONSTRAINT "MaterialRequestVoucher_approvedById_fkey";

-- DropForeignKey
ALTER TABLE "MaterialReturnVoucher" DROP CONSTRAINT "MaterialReturnVoucher_receivedById_fkey";

-- DropForeignKey
ALTER TABLE "MaterialReturnVoucher" DROP CONSTRAINT "MaterialReturnVoucher_userId_fkey";

-- DropForeignKey
ALTER TABLE "Project" DROP CONSTRAINT "Project_projectManagerId_fkey";

-- DropForeignKey
ALTER TABLE "PurchaseOrder" DROP CONSTRAINT "PurchaseOrder_approvedById_fkey";

-- DropIndex
DROP INDEX "IssueVoucherItem_id_description_key";

-- DropIndex
DROP INDEX "MaterialReceiveItem_id_description_key";

-- DropIndex
DROP INDEX "MaterialRequestItem_id_description_key";

-- DropIndex
DROP INDEX "PurchaseOrderItem_id_description_key";

-- DropIndex
DROP INDEX "ReturnVoucherItem_id_description_key";

-- AlterTable
ALTER TABLE "IssueVoucherItem" DROP COLUMN "description",
ADD COLUMN     "productId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "MaterialIssueVoucher" DROP COLUMN "issuedToId",
DROP COLUMN "projectDetails",
DROP COLUMN "userId",
ADD COLUMN     "projectId" TEXT NOT NULL,
ALTER COLUMN "approvedById" DROP NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReceiveItem" DROP COLUMN "description",
ADD COLUMN     "productId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReceiveVoucher" DROP COLUMN "projectDetails",
ADD COLUMN     "projectId" TEXT NOT NULL,
ALTER COLUMN "approvedById" DROP NOT NULL;

-- AlterTable
ALTER TABLE "MaterialRequestItem" DROP COLUMN "description",
ADD COLUMN     "productId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "MaterialRequestVoucher" ADD COLUMN     "projectId" TEXT NOT NULL,
ALTER COLUMN "approvedById" DROP NOT NULL;

-- AlterTable
ALTER TABLE "MaterialReturnVoucher" DROP COLUMN "userId",
ADD COLUMN     "projectId" TEXT NOT NULL,
ALTER COLUMN "receivedById" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Product" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "Project" DROP COLUMN "projectManagerId";

-- AlterTable
ALTER TABLE "PurchaseOrder" DROP COLUMN "dateOfReceiving",
DROP COLUMN "projectDetails",
ADD COLUMN     "projectId" TEXT NOT NULL,
ALTER COLUMN "approvedById" DROP NOT NULL;

-- AlterTable
ALTER TABLE "PurchaseOrderItem" DROP COLUMN "description",
ADD COLUMN     "productId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "ReturnVoucherItem" DROP COLUMN "description",
ADD COLUMN     "productId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "WarehouseProduct" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "WarehouseStore" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- CreateTable
CREATE TABLE "ProjectUser" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProjectUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WarehouseStoreManager" (
    "id" TEXT NOT NULL,
    "warehouseStoreId" TEXT NOT NULL,
    "storeManagerId" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "ProjectUser_projectId_userId_key" ON "ProjectUser"("projectId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "WarehouseStoreManager_warehouseStoreId_storeManagerId_key" ON "WarehouseStoreManager"("warehouseStoreId", "storeManagerId");

-- CreateIndex
CREATE UNIQUE INDEX "IssueVoucherItem_id_productId_key" ON "IssueVoucherItem"("id", "productId");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialReceiveItem_id_productId_key" ON "MaterialReceiveItem"("id", "productId");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialRequestItem_id_productId_key" ON "MaterialRequestItem"("id", "productId");

-- CreateIndex
CREATE UNIQUE INDEX "PurchaseOrderItem_id_productId_key" ON "PurchaseOrderItem"("id", "productId");

-- CreateIndex
CREATE UNIQUE INDEX "ReturnVoucherItem_id_productId_key" ON "ReturnVoucherItem"("id", "productId");

-- AddForeignKey
ALTER TABLE "ProjectUser" ADD CONSTRAINT "ProjectUser_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectUser" ADD CONSTRAINT "ProjectUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WarehouseStoreManager" ADD CONSTRAINT "WarehouseStoreManager_warehouseStoreId_fkey" FOREIGN KEY ("warehouseStoreId") REFERENCES "WarehouseStore"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WarehouseStoreManager" ADD CONSTRAINT "WarehouseStoreManager_storeManagerId_fkey" FOREIGN KEY ("storeManagerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrder" ADD CONSTRAINT "PurchaseOrder_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrder" ADD CONSTRAINT "PurchaseOrder_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrderItem" ADD CONSTRAINT "PurchaseOrderItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReturnVoucher" ADD CONSTRAINT "MaterialReturnVoucher_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReturnVoucher" ADD CONSTRAINT "MaterialReturnVoucher_receivedById_fkey" FOREIGN KEY ("receivedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReturnVoucherItem" ADD CONSTRAINT "ReturnVoucherItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialIssueVoucher" ADD CONSTRAINT "MaterialIssueVoucher_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialIssueVoucher" ADD CONSTRAINT "MaterialIssueVoucher_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IssueVoucherItem" ADD CONSTRAINT "IssueVoucherItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveVoucher" ADD CONSTRAINT "MaterialReceiveVoucher_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveVoucher" ADD CONSTRAINT "MaterialReceiveVoucher_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveItem" ADD CONSTRAINT "MaterialReceiveItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialRequestVoucher" ADD CONSTRAINT "MaterialRequestVoucher_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialRequestVoucher" ADD CONSTRAINT "MaterialRequestVoucher_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialRequestItem" ADD CONSTRAINT "MaterialRequestItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
