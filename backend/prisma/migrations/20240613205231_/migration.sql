/*
  Warnings:

  - You are about to drop the column `executedBy` on the `DailySiteDataTask` table. All the data in the column will be lost.
  - You are about to drop the column `quantity` on the `DailySiteDataTaskMaterial` table. All the data in the column will be lost.
  - You are about to drop the `DailySiteDataTaskEquipment` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `date` to the `DailySiteData` table without a default value. This is not possible if the table is not empty.
  - Added the required column `quantityUsed` to the `DailySiteDataTaskMaterial` table without a default value. This is not possible if the table is not empty.
  - Added the required column `quantityWasted` to the `DailySiteDataTaskMaterial` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "DailySiteDataTask" DROP CONSTRAINT "DailySiteDataTask_dailySiteDataId_fkey";

-- DropForeignKey
ALTER TABLE "DailySiteDataTaskEquipment" DROP CONSTRAINT "DailySiteDataTaskEquipment_dailySiteDataTaskId_fkey";

-- DropForeignKey
ALTER TABLE "DailySiteDataTaskEquipment" DROP CONSTRAINT "DailySiteDataTaskEquipment_productVariantId_fkey";

-- DropForeignKey
ALTER TABLE "DailySiteDataTaskLabor" DROP CONSTRAINT "DailySiteDataTaskLabor_dailySiteDataTaskId_fkey";

-- DropForeignKey
ALTER TABLE "DailySiteDataTaskMaterial" DROP CONSTRAINT "DailySiteDataTaskMaterial_dailySiteDataTaskId_fkey";

-- DropForeignKey
ALTER TABLE "DailySiteDataTaskMaterial" DROP CONSTRAINT "DailySiteDataTaskMaterial_productVariantId_fkey";

-- AlterTable
ALTER TABLE "DailySiteData" ADD COLUMN     "date" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "DailySiteDataTask" DROP COLUMN "executedBy";

-- AlterTable
ALTER TABLE "DailySiteDataTaskMaterial" DROP COLUMN "quantity",
ADD COLUMN     "quantityUsed" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "quantityWasted" DOUBLE PRECISION NOT NULL;

-- DropTable
DROP TABLE "DailySiteDataTaskEquipment";

-- AddForeignKey
ALTER TABLE "DailySiteDataTask" ADD CONSTRAINT "DailySiteDataTask_dailySiteDataId_fkey" FOREIGN KEY ("dailySiteDataId") REFERENCES "DailySiteData"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteDataTaskLabor" ADD CONSTRAINT "DailySiteDataTaskLabor_dailySiteDataTaskId_fkey" FOREIGN KEY ("dailySiteDataTaskId") REFERENCES "DailySiteDataTask"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteDataTaskMaterial" ADD CONSTRAINT "DailySiteDataTaskMaterial_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteDataTaskMaterial" ADD CONSTRAINT "DailySiteDataTaskMaterial_dailySiteDataTaskId_fkey" FOREIGN KEY ("dailySiteDataTaskId") REFERENCES "DailySiteDataTask"("id") ON DELETE CASCADE ON UPDATE CASCADE;
