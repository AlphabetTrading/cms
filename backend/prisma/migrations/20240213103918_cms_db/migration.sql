-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('CLIENT', 'PROJECT_MANAGER', 'CONSULTANT', 'SITE_MANAGER', 'PURCHASER', 'STORE_MANAGER');

-- CreateEnum
CREATE TYPE "DocumentType" AS ENUM ('MATERIAL_REQUEST', 'MATERIAL_ISSUE', 'MATERIAL_RECEIVING', 'MATERIAL_RETURN', 'PURCHASE_ORDER');

-- CreateEnum
CREATE TYPE "ProgressStatus" AS ENUM ('PENDING', 'IN_PROGRESS', 'APPROVED', 'DENIED');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "UserRole" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PurchaseOrder" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "purchaseNumber" TEXT NOT NULL,
    "projectDetails" TEXT,
    "supplierName" TEXT NOT NULL,
    "materialRequestId" TEXT NOT NULL,
    "subtotal" DOUBLE PRECISION NOT NULL,
    "vat" DOUBLE PRECISION,
    "grandTotal" DOUBLE PRECISION,
    "preparerById" TEXT NOT NULL,
    "approvedById" TEXT NOT NULL,
    "dateOfReceiving" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PurchaseOrder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PurchaseOrderItem" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "unitOfMeasure" TEXT NOT NULL,
    "quantityRequested" INTEGER NOT NULL,
    "unitPrice" DOUBLE PRECISION NOT NULL,
    "totalPrice" DOUBLE PRECISION NOT NULL,
    "remark" TEXT,
    "purchaseOrderId" TEXT NOT NULL,

    CONSTRAINT "PurchaseOrderItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MaterialReturnVoucher" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "returnNumber" TEXT NOT NULL,
    "from" TEXT NOT NULL,
    "receivingStore" TEXT NOT NULL,
    "returnedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MaterialReturnVoucher_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReturnVoucherItem" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "issueVoucherId" TEXT NOT NULL,
    "unitOfMeasure" TEXT NOT NULL,
    "quantityReturned" INTEGER NOT NULL,
    "unitCost" DOUBLE PRECISION NOT NULL,
    "totalCost" DOUBLE PRECISION NOT NULL,
    "remark" TEXT,
    "materialReturnVoucherId" TEXT NOT NULL,

    CONSTRAINT "ReturnVoucherItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MaterialIssueVoucher" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "projectDetails" TEXT,
    "issuedToId" TEXT NOT NULL,
    "requisitionNumber" TEXT,
    "preparedById" TEXT NOT NULL,
    "approvedById" TEXT NOT NULL,
    "receivedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MaterialIssueVoucher_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IssueVoucherItem" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "unitOfMeasure" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unitCost" DOUBLE PRECISION NOT NULL,
    "totalCost" DOUBLE PRECISION NOT NULL,
    "remark" TEXT,
    "materialIssueVoucherId" TEXT NOT NULL,

    CONSTRAINT "IssueVoucherItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MaterialReceiveVoucher" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "projectDetails" TEXT NOT NULL,
    "supplierName" TEXT NOT NULL,
    "invoiceId" INTEGER NOT NULL,
    "materialRequestId" TEXT NOT NULL,
    "purchaseOrderId" TEXT NOT NULL,
    "purchasedById" TEXT NOT NULL,
    "receivedById" TEXT NOT NULL,
    "approvedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MaterialReceiveVoucher_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MaterialReceiveItem" (
    "id" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "unitOfMeasure" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unitCost" DOUBLE PRECISION NOT NULL,
    "totalCost" DOUBLE PRECISION NOT NULL,
    "materialReceiveVoucherId" TEXT NOT NULL,

    CONSTRAINT "MaterialReceiveItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MaterialRequestVoucher" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "from" TEXT NOT NULL,
    "to" TEXT NOT NULL,
    "requestedById" TEXT NOT NULL,
    "approvedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MaterialRequestVoucher_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MaterialRequestItem" (
    "id" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "unitOfMeasure" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "inStockQuantity" INTEGER,
    "toBePurchasedQuantity" INTEGER,
    "remark" TEXT,
    "materialRequestVoucherId" TEXT NOT NULL,

    CONSTRAINT "MaterialRequestItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- AddForeignKey
ALTER TABLE "PurchaseOrder" ADD CONSTRAINT "PurchaseOrder_materialRequestId_fkey" FOREIGN KEY ("materialRequestId") REFERENCES "MaterialRequestVoucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrder" ADD CONSTRAINT "PurchaseOrder_preparerById_fkey" FOREIGN KEY ("preparerById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrder" ADD CONSTRAINT "PurchaseOrder_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrderItem" ADD CONSTRAINT "PurchaseOrderItem_purchaseOrderId_fkey" FOREIGN KEY ("purchaseOrderId") REFERENCES "PurchaseOrder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReturnVoucher" ADD CONSTRAINT "MaterialReturnVoucher_returnedById_fkey" FOREIGN KEY ("returnedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReturnVoucherItem" ADD CONSTRAINT "ReturnVoucherItem_issueVoucherId_fkey" FOREIGN KEY ("issueVoucherId") REFERENCES "MaterialIssueVoucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReturnVoucherItem" ADD CONSTRAINT "ReturnVoucherItem_materialReturnVoucherId_fkey" FOREIGN KEY ("materialReturnVoucherId") REFERENCES "MaterialReturnVoucher"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialIssueVoucher" ADD CONSTRAINT "MaterialIssueVoucher_issuedToId_fkey" FOREIGN KEY ("issuedToId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialIssueVoucher" ADD CONSTRAINT "MaterialIssueVoucher_preparedById_fkey" FOREIGN KEY ("preparedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialIssueVoucher" ADD CONSTRAINT "MaterialIssueVoucher_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialIssueVoucher" ADD CONSTRAINT "MaterialIssueVoucher_receivedById_fkey" FOREIGN KEY ("receivedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IssueVoucherItem" ADD CONSTRAINT "IssueVoucherItem_materialIssueVoucherId_fkey" FOREIGN KEY ("materialIssueVoucherId") REFERENCES "MaterialIssueVoucher"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveVoucher" ADD CONSTRAINT "MaterialReceiveVoucher_materialRequestId_fkey" FOREIGN KEY ("materialRequestId") REFERENCES "MaterialRequestVoucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveVoucher" ADD CONSTRAINT "MaterialReceiveVoucher_purchaseOrderId_fkey" FOREIGN KEY ("purchaseOrderId") REFERENCES "PurchaseOrder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveVoucher" ADD CONSTRAINT "MaterialReceiveVoucher_purchasedById_fkey" FOREIGN KEY ("purchasedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveVoucher" ADD CONSTRAINT "MaterialReceiveVoucher_receivedById_fkey" FOREIGN KEY ("receivedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveVoucher" ADD CONSTRAINT "MaterialReceiveVoucher_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReceiveItem" ADD CONSTRAINT "MaterialReceiveItem_materialReceiveVoucherId_fkey" FOREIGN KEY ("materialReceiveVoucherId") REFERENCES "MaterialReceiveVoucher"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialRequestVoucher" ADD CONSTRAINT "MaterialRequestVoucher_requestedById_fkey" FOREIGN KEY ("requestedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialRequestVoucher" ADD CONSTRAINT "MaterialRequestVoucher_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialRequestItem" ADD CONSTRAINT "MaterialRequestItem_materialRequestVoucherId_fkey" FOREIGN KEY ("materialRequestVoucherId") REFERENCES "MaterialRequestVoucher"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
