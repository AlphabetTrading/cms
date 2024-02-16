/*
  Warnings:

  - You are about to drop the column `returnNumber` on the `MaterialReturnVoucher` table. All the data in the column will be lost.
  - Added the required column `receivedById` to the `MaterialReturnVoucher` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "MaterialIssueVoucher" ADD COLUMN     "userId" TEXT;

-- AlterTable
ALTER TABLE "MaterialReturnVoucher" DROP COLUMN "returnNumber",
ADD COLUMN     "receivedById" TEXT NOT NULL,
ADD COLUMN     "userId" TEXT;

-- AddForeignKey
ALTER TABLE "MaterialReturnVoucher" ADD CONSTRAINT "MaterialReturnVoucher_receivedById_fkey" FOREIGN KEY ("receivedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReturnVoucher" ADD CONSTRAINT "MaterialReturnVoucher_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialIssueVoucher" ADD CONSTRAINT "MaterialIssueVoucher_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
