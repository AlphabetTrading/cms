import { ApprovalStatus, PrismaClient, UserRole } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  await prisma.issueVoucherItem.deleteMany();
  await prisma.materialIssueVoucher.deleteMany();
  await prisma.returnVoucherItem.deleteMany();
  await prisma.materialReturnVoucher.deleteMany();
  await prisma.materialReceiveItem.deleteMany();
  await prisma.materialReceiveVoucher.deleteMany();
  await prisma.proforma.deleteMany();
  await prisma.purchaseOrderItem.deleteMany();
  await prisma.purchaseOrder.deleteMany();
  await prisma.materialRequestItem.deleteMany();
  await prisma.materialRequestVoucher.deleteMany();
  await prisma.priceHistory.deleteMany();
  await prisma.warehouseProduct.deleteMany();
  await prisma.product.deleteMany();
  await prisma.warehouseStore.deleteMany();
  await prisma.task.deleteMany();
  await prisma.milestone.deleteMany();
  await prisma.project.deleteMany();
  await prisma.user.deleteMany();

  console.log('Seeding...');

  await seedUsers();
  await seedProducts();
  await seedPriceHistory();
  await seedProjects();
  await seedMilestones();
  await seedTasks();
  await seedWarehouseStores();
  await seedWarehouseProducts();
  await seedMaterialIssueVouchers();
  await seedMaterialReturnVouchers();
  await seedMaterialRequestVouchers();
  await seedPurchaseOrders();
  await seedMaterialReceiveVouchers();
  await seedProformas();
}

async function seedUsers() {
  try {
    await prisma.user.createMany({
      data: [
        {
          email: 'site_manager@example.com',
          fullName: 'Site Manager',
          phoneNumber: '0912345670',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: 'SITE_MANAGER',
        },
        {
          email: 'project_manager@example.com',
          fullName: 'Project Manager',
          phoneNumber: '0912345671',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: 'PROJECT_MANAGER',
        },
        {
          email: 'store_manager@example.com',
          fullName: 'Store Manager',
          phoneNumber: '0912345672',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: 'STORE_MANAGER',
        },
        {
          email: 'client@example.com',
          fullName: 'Client Client',
          phoneNumber: '0912345673',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: 'CLIENT',
        },
        {
          email: 'purchaser@example.com',
          fullName: 'Purchaser Purchaser',
          phoneNumber: '0912345674',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: 'PURCHASER',
        },
        {
          email: 'consultant@example.com',
          fullName: 'Consultant Consultant',
          phoneNumber: '0912345675',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: 'CONSULTANT',
        },
        {
          email: 'site_manager2@example.com',
          fullName: 'Site Manager 2',
          phoneNumber: '0912345676',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: 'SITE_MANAGER',
        },
        {
          email: 'project_manager2@example.com',
          fullName: 'Project Manager 2',
          phoneNumber: '0912345677',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: 'PROJECT_MANAGER',
        },
        {
          email: 'store_manager2@example.com',
          fullName: 'Store Manager 2',
          phoneNumber: '0912345678',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: 'STORE_MANAGER',
        },
        {
          email: 'client2@example.com',
          fullName: 'Client Client 2',
          phoneNumber: '0912345679',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: 'CLIENT',
        },
        {
          email: 'purchaser2@example.com',
          fullName: 'Purchaser Purchaser 2',
          phoneNumber: '0912345680',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: 'PURCHASER',
        },
        {
          email: 'consultant2@example.com',
          fullName: 'Consultant Consultant 2',
          phoneNumber: '0912345681',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: 'CONSULTANT',
        },
      ],
    });
    console.log('User models seeded successfully');
  } catch (error) {
    console.error('Error seeding user models:', error);
  } finally {
    await prisma.$disconnect();
  }
}

async function seedProjects() {
  try {
    const project_managers = await prisma.user.findMany({
      where: {
        role: UserRole.PROJECT_MANAGER,
      },
    });
    const clients = await prisma.user.findMany({
      where: {
        role: UserRole.CLIENT,
      },
    });
    await prisma.project.createMany({
      data: [
        {
          name: 'Project 1',
          startDate: new Date(),
          endDate: new Date(),
          budget: 100000,
          clientId: clients[0].id,
          projectManagerId: project_managers[0].id,
          status: 'IN_PROGRESS',
        },
        {
          name: 'Project 2',
          startDate: new Date(),
          endDate: new Date(),
          budget: 200000,
          clientId: clients[1].id,
          projectManagerId: project_managers[1].id,
          status: 'COMPLETED',
        },
        {
          name: 'Project 3',
          startDate: new Date(),
          endDate: new Date(),
          budget: 300000,
          clientId: clients[0].id,
          projectManagerId: project_managers[1].id,
          status: 'IN_PROGRESS',
        },
      ],
    });
    console.log('Project models seeded successfully');
  } catch (error) {
    console.error('Error seeding project models:', error);
  }
}
async function seedMilestones() {
  try {
    const projects = await prisma.project.findMany();
    await prisma.milestone.createMany({
      data: [
        {
          name: 'Milestone 1',
          description: 'This is milestone 1',
          dueDate: new Date(),
          status: 'IN_PROGRESS',
          projectId: projects[0].id,
        },
        {
          name: 'Milestone 2',
          description: 'This is milestone 2',
          dueDate: new Date(),
          status: 'COMPLETED',
          projectId: projects[0].id,
        },
        {
          name: 'Milestone 3',
          description: 'This is milestone 3',
          dueDate: new Date(),
          status: 'COMPLETED',
          projectId: projects[1].id,
        },
        {
          name: 'Milestone 4',
          description: 'This is milestone 4',
          dueDate: new Date(),
          status: 'IN_PROGRESS',
          projectId: projects[1].id,
        },
        {
          name: 'Milestone 5',
          description: 'This is milestone 5',
          dueDate: new Date(),
          status: 'COMPLETED',
          projectId: projects[2].id,
        },
        {
          name: 'Milestone 6',
          description: 'This is milestone 6',
          dueDate: new Date(),
          status: 'IN_PROGRESS',
          projectId: projects[2].id,
        },
      ],
    });
    console.log('Milestone models seeded successfully');
  } catch (error) {
    console.error('Error seeding milestone models:', error);
  }
}
async function seedTasks() {
  try {
    const users = await prisma.user.findMany();
    const milestones = await prisma.milestone.findMany();
    await prisma.task.createMany({
      data: [
        {
          name: 'Task 1',
          description: 'This is task 1',
          startDate: new Date(),
          dueDate: new Date(),
          status: 'IN_PROGRESS',
          priority: 'HIGH',
          assignedToId: users[0].id,
          milestoneId: milestones[0].id,
        },
        {
          name: 'Task 2',
          description: 'This is task 2',
          startDate: new Date(),
          dueDate: new Date(),
          status: 'COMPLETED',
          priority: 'MEDIUM',
          assignedToId: users[1].id,
          milestoneId: milestones[0].id,
        },
        {
          name: 'Task 3',
          description: 'This is task 3',
          startDate: new Date(),
          dueDate: new Date(),
          status: 'COMPLETED',
          priority: 'LOW',
          assignedToId: users[1].id,
          milestoneId: milestones[1].id,
        },

        {
          name: 'Task 4',
          description: 'This is task 4',
          startDate: new Date(),
          dueDate: new Date(),
          status: 'COMPLETED',
          priority: 'LOW',
          assignedToId: users[3].id,
          milestoneId: milestones[1].id,
        },

        {
          name: 'Task 5',
          description: 'This is task 5',
          startDate: new Date(),
          dueDate: new Date(),
          status: 'COMPLETED',
          priority: 'LOW',
          assignedToId: users[2].id,
          milestoneId: milestones[2].id,
        },
      ],
    });
    console.log('Task models seeded successfully');
  } catch (error) {
    console.error('Error seeding task models:', error);
  }
}

async function seedProducts() {
  try {
    await prisma.product.createMany({
      data: [
        {
          name: 'Product 1',
          description: 'This is product 1',
        },
        {
          name: 'Product 2',
          description: 'This is product 2',
        },
        {
          name: 'Product 3',
          description: 'This is product 3',
        },
        {
          name: 'Product 4',
          description: 'This is product 4',
        },
        {
          name: 'Product 5',
          description: 'This is product 5',
        },
      ],
    });
    console.log('Product models seeded successfully');
  } catch (error) {
    console.error('Error seeding product models:', error);
  }
}

async function seedWarehouseStores() {
  try {
    await prisma.warehouseStore.createMany({
      data: [
        {
          name: 'Warehouse 1',
          location: 'Location 1',
        },
        {
          name: 'Warehouse 2',
          location: 'Location 2',
        },
        {
          name: 'Warehouse 3',
          location: 'Location 3',
        },
        {
          name: 'Warehouse 4',
          location: 'Location 4',
        },
        {
          name: 'Warehouse 5',
          location: 'Location 5',
        },
      ],
    });
    console.log('WarehouseStore models seeded successfully');
  } catch (error) {
    console.error('Error seeding WarehouseStore models:', error);
  }
}

async function seedWarehouseProducts() {
  try {
    const products = await prisma.product.findMany();
    const warehouseStores = await prisma.warehouseStore.findMany();
    await prisma.warehouseProduct.createMany({
      data: products
        .map((product) => {
          return warehouseStores.map((warehouseStore) => {
            return {
              productId: product.id,
              warehouseId: warehouseStore.id,
              quantity: Math.floor(Math.random() * 100),
            };
          });
        })
        .flat(),
    });
    console.log('WarehouseProduct models seeded successfully');
  } catch (error) {
    console.error('Error seeding WarehouseProduct models:', error);
  }
}
async function seedPriceHistory() {
  try {
    const products = await prisma.product.findMany();
    await prisma.priceHistory.createMany({
      data: products
        .map((product) => {
          return {
            productId: product.id,
            price: 100,
          };
        })
        .flat(),
    });

    console.log('Price history seeded successfully');
  } catch (error) {
    console.error('Error seeding price history:', error);
  }
}
async function seedMaterialIssueVouchers() {
  let currentSerialNumber = 1;
  function generateSerialNumber(): string {
    const paddedSerialNumber =
      'ISS/' + currentSerialNumber.toString().padStart(3, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }
  const store_managers = await prisma.user.findMany({
    where: { role: 'STORE_MANAGER' },
  });
  const site_managers = await prisma.user.findMany({
    where: { role: 'SITE_MANAGER' },
  });

  try {
    const issueVouchers = [
      {
        serialNumber: generateSerialNumber(),
        approvedById: store_managers[0].id,
        issuedToId: store_managers[0].id,
        preparedById: site_managers[0].id,
        status: ApprovalStatus.COMPLETED,
      },
      {
        serialNumber: generateSerialNumber(),
        approvedById: store_managers[0].id,
        issuedToId: store_managers[0].id,
        preparedById: site_managers[0].id,
        status: ApprovalStatus.PENDING,
      },

      {
        serialNumber: generateSerialNumber(),
        approvedById: store_managers[0].id,
        issuedToId: store_managers[0].id,
        preparedById: site_managers[0].id,
        status: ApprovalStatus.DECLINED,
      },
      {
        serialNumber: generateSerialNumber(),
        approvedById: store_managers[0].id,
        issuedToId: store_managers[0].id,
        preparedById: site_managers[1].id,
        status: ApprovalStatus.COMPLETED,
      },
      {
        serialNumber: generateSerialNumber(),
        approvedById: store_managers[1].id,
        issuedToId: store_managers[1].id,
        preparedById: site_managers[0].id,
        status: ApprovalStatus.PENDING,
      },

      {
        serialNumber: generateSerialNumber(),
        approvedById: store_managers[1].id,
        issuedToId: store_managers[1].id,
        preparedById: site_managers[1].id,
        status: ApprovalStatus.DECLINED,
      },
    ];

    for (const data of issueVouchers) {
      await prisma.materialIssueVoucher.create({
        data: {
          ...data,
          items: {
            create: [
              {
                listNo: 1,
                quantity: 2,
                description: 'Cement',
                totalCost: 100,
                unitCost: 50,
                unitOfMeasure: 'quintal',
              },
              {
                listNo: 2,
                quantity: 20,
                description: 'Steel',
                totalCost: 100,
                unitCost: 5,
                unitOfMeasure: 'kg',
              },
            ],
          },
        },
      });
    }
    console.log('Material Issue models seeded successfully');
  } catch (error) {
    console.error('Error seeding material Issue models:', error);
  } finally {
    await prisma.$disconnect();
  }
}

async function seedMaterialReturnVouchers() {
  let currentSerialNumber = 1;
  function generateSerialNumber(): string {
    const paddedSerialNumber =
      'RTN/' + currentSerialNumber.toString().padStart(3, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }
  const store_managers = await prisma.user.findMany({
    where: { role: 'STORE_MANAGER' },
  });
  const site_managers = await prisma.user.findMany({
    where: { role: 'SITE_MANAGER' },
  });
  const warehouse_stores = await prisma.warehouseStore.findMany();
  const material_issues = await prisma.materialIssueVoucher.findMany();
  try {
    const returnVouchers = [
      {
        serialNumber: generateSerialNumber(),
        from: site_managers[0].fullName,
        receivingStore: warehouse_stores[0].name,
        receivedById: store_managers[0].id,
        returnedById: site_managers[0].id,
        status: ApprovalStatus.COMPLETED,
      },
      {
        serialNumber: generateSerialNumber(),
        from: site_managers[0].fullName,
        receivingStore: warehouse_stores[0].name,
        receivedById: store_managers[0].id,
        returnedById: site_managers[0].id,
        status: ApprovalStatus.PENDING,
      },
      {
        serialNumber: generateSerialNumber(),
        from: site_managers[0].fullName,
        receivingStore: warehouse_stores[0].name,
        receivedById: store_managers[0].id,
        returnedById: site_managers[0].id,
        status: ApprovalStatus.DECLINED,
      },
      {
        serialNumber: generateSerialNumber(),
        from: site_managers[1].fullName,
        receivingStore: warehouse_stores[0].name,
        receivedById: store_managers[0].id,
        returnedById: site_managers[1].id,
        status: ApprovalStatus.COMPLETED,
      },
      {
        serialNumber: generateSerialNumber(),
        from: site_managers[1].fullName,
        receivingStore: warehouse_stores[0].name,
        receivedById: store_managers[1].id,
        returnedById: site_managers[1].id,
        status: ApprovalStatus.PENDING,
      },
      {
        serialNumber: generateSerialNumber(),
        from: site_managers[0].fullName,
        receivingStore: warehouse_stores[0].name,
        receivedById: store_managers[1].id,
        returnedById: site_managers[0].id,
        status: ApprovalStatus.DECLINED,
      },
    ];

    for (const data of returnVouchers) {
      await prisma.materialReturnVoucher.create({
        data: {
          ...data,
          items: {
            create: [
              {
                listNo: 1,
                quantityReturned: 10,
                issueVoucherId: material_issues[0].id,
                description: 'Cement',
                totalCost: 100,
                unitCost: 50,
                unitOfMeasure: 'quintal',
              },
              {
                listNo: 2,
                quantityReturned: 10,
                issueVoucherId: material_issues[1].id,
                description: 'Steel',
                totalCost: 100,
                unitCost: 5,
                unitOfMeasure: 'kg',
              },
              {
                listNo: 3,
                quantityReturned: 100,
                issueVoucherId: material_issues[1].id,
                description: 'Nails',
                totalCost: 150,
                unitCost: 1.5,
                unitOfMeasure: 'box',
              },
            ],
          },
        },
      });
    }
    console.log('Material Return models seeded successfully');
  } catch (error) {
    console.error('Error seeding material Return models:', error);
  } finally {
    await prisma.$disconnect();
  }
}
async function seedMaterialReceiveVouchers() {
  let currentSerialNumber = 1;
  function generateSerialNumber(): string {
    const paddedSerialNumber =
      'REC/' + currentSerialNumber.toString().padStart(3, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }
  const purchasers = await prisma.user.findMany({
    where: {
      role: UserRole.PURCHASER,
    },
  });
  const project_managers = await prisma.user.findMany({
    where: {
      role: UserRole.PROJECT_MANAGER,
    },
  });

  const material_requests = await prisma.materialRequestVoucher.findMany();
  const purchase_orders = await prisma.purchaseOrder.findMany();
  try {
    const receiveVouchers = [
      {
        serialNumber: generateSerialNumber(),
        invoiceId: '1',
        supplierName: purchase_orders[0].supplierName,
        approvedById: project_managers[0].id,
        materialRequestId: material_requests[0].id,
        purchasedById: purchasers[0].id,
        purchaseOrderId: purchase_orders[0].id,
        status: ApprovalStatus.COMPLETED,
      },
      {
        serialNumber: generateSerialNumber(),
        invoiceId: '2',
        supplierName: purchase_orders[3].supplierName,
        approvedById: project_managers[0].id,
        materialRequestId: material_requests[3].id,
        purchasedById: purchasers[0].id,
        purchaseOrderId: purchase_orders[3].id,
        status: ApprovalStatus.PENDING,
      },
      {
        serialNumber: generateSerialNumber(),
        invoiceId: '3',
        supplierName: purchase_orders[0].supplierName,
        approvedById: project_managers[1].id,
        materialRequestId: material_requests[0].id,
        purchasedById: purchasers[1].id,
        purchaseOrderId: purchase_orders[0].id,
        status: ApprovalStatus.DECLINED,
      },
      {
        serialNumber: generateSerialNumber(),
        invoiceId: '4',
        supplierName: purchase_orders[3].supplierName,
        approvedById: project_managers[1].id,
        materialRequestId: material_requests[3].id,
        purchasedById: purchasers[0].id,
        purchaseOrderId: purchase_orders[3].id,
        status: ApprovalStatus.COMPLETED,
      },
    ];

    for (const data of receiveVouchers) {
      await prisma.materialReceiveVoucher.create({
        data: {
          ...data,
          items: {
            create: [
              {
                listNo: 1,
                quantity: 10,
                description: 'Cement',
                totalCost: 100,
                unitCost: 50,
                unitOfMeasure: 'quintal',
              },
              {
                listNo: 2,
                quantity: 10,
                description: 'Steel',
                totalCost: 100,
                unitCost: 5,
                unitOfMeasure: 'kg',
              },
              {
                listNo: 3,
                quantity: 100,
                description: 'Nails',
                totalCost: 150,
                unitCost: 1.5,
                unitOfMeasure: 'box',
              },
            ],
          },
        },
      });
    }
    console.log('Material Receive models seeded successfully');
  } catch (error) {
    console.error('Error seeding material Receive models:', error);
  } finally {
    await prisma.$disconnect();
  }
}
async function seedMaterialRequestVouchers() {
  let currentSerialNumber = 1;
  function generateSerialNumber(): string {
    const paddedSerialNumber =
      'MRQ/' + currentSerialNumber.toString().padStart(3, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }
  const site_managers = await prisma.user.findMany({
    where: {
      role: UserRole.SITE_MANAGER,
    },
  });
  const project_managers = await prisma.user.findMany({
    where: {
      role: UserRole.PROJECT_MANAGER,
    },
  });

  try {
    const requestVouchers = [
      {
        from: site_managers[0].fullName,
        to: project_managers[0].fullName,
        serialNumber: generateSerialNumber(),
        requestedById: site_managers[0].id,
        approvedById: project_managers[0].id,
        status: ApprovalStatus.COMPLETED,
      },
      {
        from: site_managers[0].fullName,
        to: project_managers[1].fullName,
        serialNumber: generateSerialNumber(),
        requestedById: site_managers[0].id,
        approvedById: project_managers[1].id,
        status: ApprovalStatus.DECLINED,
      },
      {
        from: site_managers[1].fullName,
        to: project_managers[0].fullName,
        serialNumber: generateSerialNumber(),
        approvedById: project_managers[0].id,
        requestedById: site_managers[1].id,
        status: ApprovalStatus.PENDING,
      },
      {
        from: site_managers[1].fullName,
        to: project_managers[1].fullName,
        serialNumber: generateSerialNumber(),
        approvedById: project_managers[1].id,
        requestedById: site_managers[1].id,
        status: ApprovalStatus.COMPLETED,
      },
    ];

    for (const data of requestVouchers) {
      await prisma.materialRequestVoucher.create({
        data: {
          ...data,
          items: {
            create: [
              {
                listNo: 1,
                description: 'Cement',
                unitOfMeasure: 'quintal',
                quantity: 100,
                inStockQuantity: 0,
                toBePurchasedQuantity: 100,
                remark: 'Remark 1',
              },
              {
                listNo: 2,
                description: 'Steel',
                unitOfMeasure: 'kg',
                quantity: 10,
                inStockQuantity: 3,
                toBePurchasedQuantity: 7,
                remark: 'Remark 2',
              },
              {
                listNo: 3,
                description: 'Paint',
                unitOfMeasure: 'kg',
                quantity: 10,
                inStockQuantity: 10,
                toBePurchasedQuantity: 0,
                remark: 'Remark 3',
              },
            ],
          },
        },
      });
    }
    console.log('Material Request models seeded successfully');
  } catch (error) {
    console.error('Error seeding material Request models:', error);
  } finally {
    await prisma.$disconnect();
  }
}
async function seedPurchaseOrders() {
  let currentSerialNumber = 1;
  function generateSerialNumber(): string {
    const paddedSerialNumber =
      'PO/' + currentSerialNumber.toString().padStart(3, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }
  const purchasers = await prisma.user.findMany({
    where: {
      role: UserRole.PURCHASER,
    },
  });
  const project_managers = await prisma.user.findMany({
    where: {
      role: UserRole.PROJECT_MANAGER,
    },
  });
  const material_requests = await prisma.materialRequestVoucher.findMany();
  const warehouse_stores = await prisma.warehouseStore.findMany();
  
  try {
    const purchaseOrders = [
      {
        serialNumber: generateSerialNumber(),
        approvedById: project_managers[0].id,
        vat: 130.43,
        warehouseStoreId: warehouse_stores[0].id,
        subTotal: 869.57,
        supplierName: 'Supplier 1',
        grandTotal: 1000,
        materialRequestId: material_requests[0].id,
        preparedById: purchasers[0].id,
        status: ApprovalStatus.COMPLETED,
      },
      {
        serialNumber: generateSerialNumber(),
        approvedById: project_managers[0].id,
        vat: 195.65,
        warehouseStoreId: warehouse_stores[1].id,
        subTotal: 1304.35,
        supplierName: 'Supplier 2',
        grandTotal: 1500,
        materialRequestId: material_requests[0].id,
        preparedById: purchasers[0].id,
        status: ApprovalStatus.PENDING,
      },
      {
        serialNumber: generateSerialNumber(),
        approvedById: project_managers[0].id,
        vat: 104.35,
        warehouseStoreId: warehouse_stores[1].id,
        subTotal: 695.65,
        supplierName: 'Supplier 3',
        grandTotal: 800,
        materialRequestId: material_requests[0].id,
        preparedById: purchasers[0].id,
        status: ApprovalStatus.DECLINED,
      },
      {
        serialNumber: generateSerialNumber(),
        approvedById: project_managers[1].id,
        vat: 260.87,
        warehouseStoreId: warehouse_stores[2].id,
        subTotal: 1739.13,
        supplierName: 'Supplier 4',
        grandTotal: 2000,
        materialRequestId: material_requests[1].id,
        preparedById: purchasers[1].id,
        status: ApprovalStatus.COMPLETED,
      },
    ];

    for (const data of purchaseOrders) {
      await prisma.purchaseOrder.create({
        data: {
          ...data,
          items: {
            create: [
              {
                listNo: 1,
                description: 'Cement',
                quantityRequested: 10,
                totalPrice: 1000,
                unitPrice: 100,
                unitOfMeasure: 'quintal',
              },
              {
                listNo: 2,
                description: 'Steel',
                quantityRequested: 10,
                totalPrice: 1500,
                unitPrice: 150,
                unitOfMeasure: 'kg',
              },
              {
                listNo: 3,
                description: 'Ceramic',
                quantityRequested: 1000,
                totalPrice: 50000,
                unitPrice: 50,
                unitOfMeasure: 'pcs',
              },
            ],
          },
        },
      });
    }
    console.log('Purchase Order models seeded successfully');
  } catch (error) {
    console.error('Error seeding purchase order models:', error);
  } finally {
    await prisma.$disconnect();
  }
}
async function seedProformas() {
  let currentSerialNumber = 1;
  function generateSerialNumber(): string {
    const paddedSerialNumber =
      'PRO/' + currentSerialNumber.toString().padStart(3, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }
  const material_requests = await prisma.materialRequestVoucher.findMany();

  try {
    await prisma.proforma.createMany({
      data: [
        {
          serialNumber: generateSerialNumber(),
          vendor: 'Vendor 1',
          description: 'Proforma for Cement 1',
          materialRequestId: material_requests[0].id,
          photos: [''],
        },
        {
          serialNumber: generateSerialNumber(),
          vendor: 'Vendor 2',
          description: 'Proforma for Cement 2',
          materialRequestId: material_requests[2].id,
          photos: [''],
        },
        {
          serialNumber: generateSerialNumber(),
          vendor: 'Vendor 3',
          description: 'Proforma for Cement 3',
          materialRequestId: material_requests[1].id,
          photos: [''],
        },
        {
          serialNumber: generateSerialNumber(),
          vendor: 'Vendor 4',
          description: 'Proforma for Steel 1',
          materialRequestId: material_requests[0].id,
          photos: [''],
        },
        {
          serialNumber: generateSerialNumber(),
          vendor: 'Vendor 5',
          description: 'Proforma for Steel 2',
          materialRequestId: material_requests[2].id,
          photos: [''],
        },
        {
          serialNumber: generateSerialNumber(),
          vendor: 'Vendor 6',
          description: 'Proforma for Steel 3',
          materialRequestId: material_requests[1].id,
          photos: [''],
        },
      ],
    });
    console.log('Proforma models seeded successfully');
  } catch (error) {
    console.error('Error seeding proforma models:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main()
  .catch((e) => console.error(e))
  .finally(async () => {
    await prisma.$disconnect();
  });
