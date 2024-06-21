/*
  Warnings:

  - Added the required column `number` to the `DailySiteDataTaskLabor` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "DailySiteDataTaskLabor" ADD COLUMN     "number" INTEGER NOT NULL;
