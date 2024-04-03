/*
  Warnings:

  - Added the required column `projectId` to the `Proforma` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Proforma" ADD COLUMN     "projectId" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "Proforma" ADD CONSTRAINT "Proforma_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
