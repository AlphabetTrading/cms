/*
  Warnings:

  - You are about to drop the column `status` on the `Milestone` table. All the data in the column will be lost.
  - You are about to drop the column `startDate` on the `Task` table. All the data in the column will be lost.
  - The `status` column on the `Task` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `priority` column on the `Task` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Added the required column `createdById` to the `Milestone` table without a default value. This is not possible if the table is not empty.
  - Added the required column `stage` to the `Milestone` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "CompletionStatus" AS ENUM ('TODO', 'ONGOING', 'COMPLETED');

-- CreateEnum
CREATE TYPE "Priority" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');

-- AlterTable
ALTER TABLE "Milestone" DROP COLUMN "status",
ADD COLUMN     "createdById" TEXT NOT NULL,
ADD COLUMN     "stage" "UseType" NOT NULL;

-- AlterTable
ALTER TABLE "Task" DROP COLUMN "startDate",
ALTER COLUMN "dueDate" DROP NOT NULL,
DROP COLUMN "status",
ADD COLUMN     "status" "CompletionStatus" NOT NULL DEFAULT 'TODO',
DROP COLUMN "priority",
ADD COLUMN     "priority" "Priority" NOT NULL DEFAULT 'LOW';

-- AddForeignKey
ALTER TABLE "Milestone" ADD CONSTRAINT "Milestone_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
