/*
  Warnings:

  - You are about to drop the column `description` on the `Proforma` table. All the data in the column will be lost.
  - You are about to drop the column `materialRequestId` on the `Proforma` table. All the data in the column will be lost.
  - You are about to drop the column `photos` on the `Proforma` table. All the data in the column will be lost.
  - Added the required column `materialRequestItemId` to the `Proforma` table without a default value. This is not possible if the table is not empty.
  - Added the required column `photo` to the `Proforma` table without a default value. This is not possible if the table is not empty.
  - Added the required column `preparedById` to the `Proforma` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Proforma" DROP CONSTRAINT "Proforma_materialRequestId_fkey";

-- AlterTable
ALTER TABLE "Proforma" DROP COLUMN "description",
DROP COLUMN "materialRequestId",
DROP COLUMN "photos",
ADD COLUMN     "approvedById" TEXT,
ADD COLUMN     "materialRequestItemId" TEXT NOT NULL,
ADD COLUMN     "photo" TEXT NOT NULL,
ADD COLUMN     "preparedById" TEXT NOT NULL,
ADD COLUMN     "remark" TEXT,
ADD COLUMN     "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING';

-- AddForeignKey
ALTER TABLE "Proforma" ADD CONSTRAINT "Proforma_preparedById_fkey" FOREIGN KEY ("preparedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Proforma" ADD CONSTRAINT "Proforma_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Proforma" ADD CONSTRAINT "Proforma_materialRequestItemId_fkey" FOREIGN KEY ("materialRequestItemId") REFERENCES "MaterialRequestItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
