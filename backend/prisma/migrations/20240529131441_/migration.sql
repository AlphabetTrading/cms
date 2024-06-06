-- AlterTable
ALTER TABLE "WarehouseProduct" ADD COLUMN     "version" INTEGER NOT NULL DEFAULT 1;

-- CreateTable
CREATE TABLE "DailyStockBalance" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "changes" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DailyStockBalance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DailySiteData" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "contractor" TEXT,
    "preparedById" TEXT NOT NULL,
    "checkedById" TEXT,
    "approvedById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DailySiteData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DailySiteDataTask" (
    "id" TEXT NOT NULL,
    "executedBy" TEXT,
    "description" TEXT NOT NULL,
    "executedQuantity" DOUBLE PRECISION,
    "unit" TEXT,
    "dailySiteDataId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DailySiteDataTask_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DailySiteDataTaskLabor" (
    "id" TEXT NOT NULL,
    "trade" TEXT,
    "morning" DOUBLE PRECISION,
    "afternoon" DOUBLE PRECISION,
    "overtime" DOUBLE PRECISION,
    "dailySiteDataTaskId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DailySiteDataTaskLabor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DailySiteDataTaskMaterial" (
    "id" TEXT NOT NULL,
    "productVariantId" TEXT NOT NULL,
    "quantity" DOUBLE PRECISION NOT NULL,
    "dailySiteDataTaskId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DailySiteDataTaskMaterial_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DailySiteDataTaskEquipment" (
    "id" TEXT NOT NULL,
    "productVariantId" TEXT NOT NULL,
    "quantity" DOUBLE PRECISION NOT NULL,
    "morning" DOUBLE PRECISION,
    "afternoon" DOUBLE PRECISION,
    "dailySiteDataTaskId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DailySiteDataTaskEquipment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "DailySiteDataTaskLabor_id_trade_key" ON "DailySiteDataTaskLabor"("id", "trade");

-- CreateIndex
CREATE UNIQUE INDEX "DailySiteDataTaskMaterial_id_productVariantId_key" ON "DailySiteDataTaskMaterial"("id", "productVariantId");

-- CreateIndex
CREATE UNIQUE INDEX "DailySiteDataTaskEquipment_id_productVariantId_key" ON "DailySiteDataTaskEquipment"("id", "productVariantId");

-- AddForeignKey
ALTER TABLE "DailyStockBalance" ADD CONSTRAINT "DailyStockBalance_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteData" ADD CONSTRAINT "DailySiteData_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteData" ADD CONSTRAINT "DailySiteData_preparedById_fkey" FOREIGN KEY ("preparedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteData" ADD CONSTRAINT "DailySiteData_checkedById_fkey" FOREIGN KEY ("checkedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteData" ADD CONSTRAINT "DailySiteData_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteDataTask" ADD CONSTRAINT "DailySiteDataTask_dailySiteDataId_fkey" FOREIGN KEY ("dailySiteDataId") REFERENCES "DailySiteData"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteDataTaskLabor" ADD CONSTRAINT "DailySiteDataTaskLabor_dailySiteDataTaskId_fkey" FOREIGN KEY ("dailySiteDataTaskId") REFERENCES "DailySiteDataTask"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteDataTaskMaterial" ADD CONSTRAINT "DailySiteDataTaskMaterial_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteDataTaskMaterial" ADD CONSTRAINT "DailySiteDataTaskMaterial_dailySiteDataTaskId_fkey" FOREIGN KEY ("dailySiteDataTaskId") REFERENCES "DailySiteDataTask"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteDataTaskEquipment" ADD CONSTRAINT "DailySiteDataTaskEquipment_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailySiteDataTaskEquipment" ADD CONSTRAINT "DailySiteDataTaskEquipment_dailySiteDataTaskId_fkey" FOREIGN KEY ("dailySiteDataTaskId") REFERENCES "DailySiteDataTask"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
