-- CreateTable
CREATE TABLE "Proforma" (
    "id" TEXT NOT NULL,
    "serialNumber" TEXT NOT NULL,
    "vendor" TEXT NOT NULL,
    "description" TEXT,
    "photos" TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "materialRequestId" TEXT NOT NULL,

    CONSTRAINT "Proforma_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Proforma_serialNumber_key" ON "Proforma"("serialNumber");

-- AddForeignKey
ALTER TABLE "Proforma" ADD CONSTRAINT "Proforma_materialRequestId_fkey" FOREIGN KEY ("materialRequestId") REFERENCES "MaterialRequestVoucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;
