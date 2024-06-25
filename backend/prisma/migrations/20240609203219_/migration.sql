/*
  Warnings:

  - You are about to drop the column `clientId` on the `Project` table. All the data in the column will be lost.
  - You are about to drop the column `projectManagerId` on the `Project` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[companyId,name]` on the table `Project` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `companyId` to the `Project` table without a default value. This is not possible if the table is not empty.
  - Added the required column `companyId` to the `WarehouseStore` table without a default value. This is not possible if the table is not empty.

*/
-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "UserRole" ADD VALUE 'ADMIN';
ALTER TYPE "UserRole" ADD VALUE 'OWNER';

-- DropForeignKey
ALTER TABLE "Project" DROP CONSTRAINT "Project_clientId_fkey";

-- DropForeignKey
ALTER TABLE "Project" DROP CONSTRAINT "Project_projectManagerId_fkey";

-- DropIndex
DROP INDEX "Project_name_key";

-- AlterTable
ALTER TABLE "Project" DROP COLUMN "clientId",
DROP COLUMN "projectManagerId",
ADD COLUMN     "companyId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "companyId" TEXT,
ADD COLUMN     "invitationToken" TEXT,
ADD COLUMN     "invited" BOOLEAN NOT NULL DEFAULT false,
ALTER COLUMN "password" DROP NOT NULL;

-- AlterTable
ALTER TABLE "WarehouseStore" ADD COLUMN     "companyId" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "Company" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "contactInfo" TEXT NOT NULL,
    "ownerId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CompanyEmployees" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Company_name_key" ON "Company"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Company_address_key" ON "Company"("address");

-- CreateIndex
CREATE UNIQUE INDEX "Company_ownerId_key" ON "Company"("ownerId");

-- CreateIndex
CREATE UNIQUE INDEX "_CompanyEmployees_AB_unique" ON "_CompanyEmployees"("A", "B");

-- CreateIndex
CREATE INDEX "_CompanyEmployees_B_index" ON "_CompanyEmployees"("B");

-- CreateIndex
CREATE UNIQUE INDEX "Project_companyId_name_key" ON "Project"("companyId", "name");

-- AddForeignKey
ALTER TABLE "Company" ADD CONSTRAINT "Company_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WarehouseStore" ADD CONSTRAINT "WarehouseStore_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompanyEmployees" ADD CONSTRAINT "_CompanyEmployees_A_fkey" FOREIGN KEY ("A") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompanyEmployees" ADD CONSTRAINT "_CompanyEmployees_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
