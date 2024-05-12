-- CreateTable
CREATE TABLE "MaterialTransferVoucher" (
    "id" TEXT NOT NULL,
    "serialNumber" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "requisitionNumber" TEXT,
    "materialGroup" TEXT,
    "sendingStore" TEXT,
    "receivingStore" TEXT,
    "vehiclePlateNo" TEXT,
    "materialReceiveId" TEXT,
    "preparedById" TEXT NOT NULL,
    "approvedById" TEXT,
    "sentThroughName" TEXT,
    "status" "ApprovalStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MaterialTransferVoucher_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MaterialTransferItem" (
    "id" TEXT NOT NULL,
    "productVariantId" TEXT NOT NULL,
    "quantityRequested" DOUBLE PRECISION,
    "quantityTransferred" DOUBLE PRECISION NOT NULL,
    "unitCost" DOUBLE PRECISION NOT NULL,
    "totalCost" DOUBLE PRECISION NOT NULL,
    "remark" TEXT,
    "materialTransferVoucherId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MaterialTransferItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "MaterialTransferVoucher_serialNumber_key" ON "MaterialTransferVoucher"("serialNumber");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialTransferItem_id_productVariantId_key" ON "MaterialTransferItem"("id", "productVariantId");

-- AddForeignKey
ALTER TABLE "MaterialTransferVoucher" ADD CONSTRAINT "MaterialTransferVoucher_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialTransferVoucher" ADD CONSTRAINT "MaterialTransferVoucher_preparedById_fkey" FOREIGN KEY ("preparedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialTransferVoucher" ADD CONSTRAINT "MaterialTransferVoucher_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialTransferItem" ADD CONSTRAINT "MaterialTransferItem_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialTransferItem" ADD CONSTRAINT "MaterialTransferItem_materialTransferVoucherId_fkey" FOREIGN KEY ("materialTransferVoucherId") REFERENCES "MaterialTransferVoucher"("id") ON DELETE SET NULL ON UPDATE CASCADE;
