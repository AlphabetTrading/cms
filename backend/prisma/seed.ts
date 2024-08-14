import {
  ApprovalStatus,
  PrismaClient,
  SuperStructureUseDescription,
  UnitOfMeasure,
  UseType,
  UserRole,
} from '@prisma/client';
import { faker } from '@faker-js/faker';
const prisma = new PrismaClient();

async function main() {
  await prisma.issueVoucherItem.deleteMany();
  await prisma.materialIssueVoucher.deleteMany();
  await prisma.returnVoucherItem.deleteMany();
  await prisma.materialReturnVoucher.deleteMany();
  await prisma.materialReceiveItem.deleteMany();
  await prisma.materialReceiveVoucher.deleteMany();
  await prisma.purchaseOrderItem.deleteMany();
  await prisma.purchaseOrder.deleteMany();
  await prisma.proforma.deleteMany();
  await prisma.materialRequestItem.deleteMany();
  await prisma.materialRequestVoucher.deleteMany();
  await prisma.materialTransferItem.deleteMany();
  await prisma.materialTransferVoucher.deleteMany();
  await prisma.dailySiteDataTaskMaterial.deleteMany();
  await prisma.dailySiteDataTaskLabor.deleteMany();
  await prisma.dailySiteDataTask.deleteMany();
  await prisma.dailySiteData.deleteMany();
  await prisma.dailyStockBalance.deleteMany();
  await prisma.priceHistory.deleteMany();
  await prisma.warehouseProduct.deleteMany();
  await prisma.productVariant.deleteMany();
  await prisma.product.deleteMany();
  await prisma.warehouseStoreManager.deleteMany();
  await prisma.warehouseStore.deleteMany();
  await prisma.task.deleteMany();
  await prisma.milestone.deleteMany();
  await prisma.projectUser.deleteMany();
  await prisma.project.deleteMany();
  await prisma.company.deleteMany();
  await prisma.user.deleteMany();

  console.log('Seeding...');

  await seedOwners();
  await seedCompanies();
  await seedUsers();
  await seedProducts();
  await seedProductVariants();
  await seedProjects();
  await seedProjectUsers();
  await seedMilestones();
  await seedTasks();
  await seedWarehouseStores();
  await seedWarehouseStoreManagers();
  await seedWarehouseProducts();
  await seedMaterialIssueVouchers();
  await seedMaterialReturnVouchers();
  await seedMaterialRequestVouchers();
  await seedProformas();
  await seedPurchaseOrders();
  await seedMaterialReceiveVouchers();
  await seedMaterialTransferVouchers();
  await seedDailySiteData();
}

async function seedOwners() {
  try {
    await prisma.user.createMany({
      data: [
        {
          email: faker.internet.email(),
          fullName: faker.person.fullName(),
          phoneNumber: '0900010203',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: UserRole.OWNER,
        },
        {
          email: faker.internet.email(),
          fullName: faker.person.fullName(),
          phoneNumber: '0900010204',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: UserRole.OWNER,
        },

        {
          email: faker.internet.email(),
          fullName: faker.person.fullName(),
          phoneNumber: '0900010205',
          password:
            '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
          role: UserRole.OWNER,
        },
      ],
    });
    console.log('Owners seeded successfully');
  } catch (error) {
    console.error('Error seeding owners:', error);
  } finally {
    await prisma.$disconnect();
  }
}

async function seedCompanies() {
  try {
    const owners = await prisma.user.findMany();

    for (let i = 0; i < 3; i++) {
      await prisma.company.create({
        data: {
          name: faker.company.name(),
          address: faker.location.city() + ', ' + faker.location.country(),
          contactInfo: faker.internet.email(),
          ownerId: owners[i].id,
        },
      });
    }
    console.log('Company models seeded successfully');
  } catch (error) {
    console.error('Error seeding company models:', error);
  } finally {
    await prisma.$disconnect();
  }
}

async function seedUsers() {
  try {
    const companies = await prisma.company.findMany();
    const phoneNumber = '0912345';
    let remainingDigits = 670;
    const roles = [
      UserRole.SITE_MANAGER,
      UserRole.PROJECT_MANAGER,
      UserRole.STORE_MANAGER,
      UserRole.CLIENT,
      UserRole.PURCHASER,
      UserRole.CONSULTANT,
    ];
    for (const company of companies) {
      for (let i = 0; i < 2; i++) {
        for (const role of roles) {
          await prisma.user.create({
            data: {
              email: faker.internet.email(),
              fullName: faker.person.fullName(),
              phoneNumber: phoneNumber + remainingDigits.toString(),
              password:
                '$2b$10$EpRnTzVlqHNP0.fUbXUwSOyuiXe/QLSUG6xNekdHgTGmrpHEfIoxm',
              role: role,
              companyId: company.id,
            },
          });
          remainingDigits++;
        }
      }
    }
    console.log('User models seeded successfully');
  } catch (error) {
    console.error('Error seeding user models:', error);
  } finally {
    await prisma.$disconnect();
  }
}

async function seedProjects() {
  try {
    const companies = await prisma.company.findMany();
    for (const company of companies) {
      await prisma.project.createMany({
        data: [
          {
            name: 'Project 1',
            companyId: company.id,
            startDate: new Date(),
            endDate: new Date(),
            budget: 100000,
            status: 'IN_PROGRESS',
          },
          {
            name: 'Project 2',
            companyId: company.id,
            startDate: new Date(),
            endDate: new Date(),
            budget: 200000,
            status: 'COMPLETED',
          },
          {
            name: 'Project 3',
            companyId: company.id,
            startDate: new Date(),
            endDate: new Date(),
            budget: 300000,
            status: 'IN_PROGRESS',
          },
        ],
      });
    }
    console.log('Project models seeded successfully');
  } catch (error) {
    console.error('Error seeding project models:', error);
  }
}

async function seedProjectUsers() {
  try {
    const companies = await prisma.company.findMany();

    for (const company of companies) {
      const projects = await prisma.project.findMany({
        where: {
          companyId: company.id,
        },
      });
      const clients = await prisma.user.findMany({
        where: { role: UserRole.CLIENT, companyId: company.id },
      });
      const projectManagers = await prisma.user.findMany({
        where: { role: UserRole.PROJECT_MANAGER, companyId: company.id },
      });
      const consultants = await prisma.user.findMany({
        where: { role: UserRole.CONSULTANT, companyId: company.id },
      });
      const siteManagers = await prisma.user.findMany({
        where: { role: UserRole.SITE_MANAGER, companyId: company.id },
      });
      const purchasers = await prisma.user.findMany({
        where: { role: UserRole.PURCHASER, companyId: company.id },
      });

      for (let i = 0; i < 2; i++) {
        if (clients.length > 0) {
          await prisma.projectUser.create({
            data: {
              projectId: projects[i].id,
              userId: clients[i].id,
            },
          });
        }

        if (projectManagers.length > 0) {
          await prisma.projectUser.create({
            data: {
              projectId: projects[i].id,
              userId: projectManagers[i].id,
            },
          });
        }

        if (consultants.length > 0) {
          await prisma.projectUser.create({
            data: {
              projectId: projects[i].id,
              userId: consultants[i].id,
            },
          });
        }

        if (siteManagers.length > 0) {
          await prisma.projectUser.create({
            data: {
              projectId: projects[i].id,
              userId: siteManagers[i].id,
            },
          });
        }

        if (purchasers.length > 0) {
          await prisma.projectUser.create({
            data: {
              projectId: projects[i].id,
              userId: purchasers[i].id,
            },
          });
        }
      }
    }

    console.log('Project Users seeded successfully');
  } catch (error) {
    console.error('Error seeding Project Users:', error);
  }
}

async function seedMilestones() {
  try {
    const projects = await prisma.project.findMany({
      include: {
        ProjectUsers: {
          where: {
            user: {
              role: UserRole.PROJECT_MANAGER,
            },
          },
          include: {
            user: true,
          },
        },
      },
    });
    await prisma.milestone.createMany({
      data: [
        {
          name: 'Milestone 1',
          stage: UseType.SUB_STRUCTURE,
          description: 'This is milestone 1',
          dueDate: new Date(),
          projectId: projects[0].id,
          createdById: projects[0].ProjectUsers[0].userId,
        },
        {
          name: 'Milestone 2',
          stage: UseType.SUPER_STRUCTURE,
          description: 'This is milestone 2',
          dueDate: new Date(),
          projectId: projects[0].id,
          createdById: projects[0].ProjectUsers[0].userId,
        },
        {
          name: 'Milestone 3',
          stage: UseType.SUPER_STRUCTURE,
          description: 'This is milestone 3',
          dueDate: new Date(),
          projectId: projects[1].id,
          createdById: projects[1].ProjectUsers[0].userId,
        },
        {
          name: 'Milestone 4',
          stage: UseType.SUB_STRUCTURE,
          description: 'This is milestone 4',
          dueDate: new Date(),
          projectId: projects[1].id,
          createdById: projects[1].ProjectUsers[0].userId,
        },
        {
          name: 'Milestone 5',
          stage: UseType.SUPER_STRUCTURE,
          description: 'This is milestone 5',
          dueDate: new Date(),
          projectId: projects[0].id,
          createdById: projects[0].ProjectUsers[0].userId,
        },
        {
          name: 'Milestone 6',
          stage: UseType.SUB_STRUCTURE,
          description: 'This is milestone 6',
          dueDate: new Date(),
          projectId: projects[1].id,
          createdById: projects[1].ProjectUsers[0].userId,
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
    const milestones = await prisma.milestone.findMany({
      include: {
        Project: true,
      },
    });
    await prisma.task.createMany({
      data: [
        {
          name: 'Task 1',
          description: 'This is task 1',
          dueDate: new Date(),
          status: 'TODO',
          priority: 'HIGH',
          assignedToId: users[0].id,
          milestoneId: milestones[0].id,
        },
        {
          name: 'Task 2',
          description: 'This is task 2',
          dueDate: new Date(),
          status: 'ONGOING',
          priority: 'MEDIUM',
          assignedToId: users[1].id,
          milestoneId: milestones[0].id,
        },
        {
          name: 'Task 3',
          description: 'This is task 3',
          dueDate: new Date(),
          status: 'COMPLETED',
          priority: 'LOW',
          assignedToId: users[1].id,
          milestoneId: milestones[1].id,
        },

        {
          name: 'Task 4',
          description: 'This is task 4',
          dueDate: new Date(),
          status: 'COMPLETED',
          priority: 'CRITICAL',
          assignedToId: users[3].id,
          milestoneId: milestones[1].id,
        },

        {
          name: 'Task 5',
          description: 'This is task 5',
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
          name: 'Reinforcement Bar',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Cement',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Sand',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Aggregate',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Nail',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Black Wire',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Block',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Admixture',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Wood',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Morale',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Bonda',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Roof',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Waterproof',
          productType: 'CONSTRUCTION',
        },
        {
          name: 'Paint',
          productType: 'CONSTRUCTION',
        },
      ],
    });
    console.log('Product models seeded successfully');
  } catch (error) {
    console.error('Error seeding product models:', error);
  }
}

async function seedProductVariants() {
  try {
    const products = await prisma.product.findMany();
    for (const product of products) {
      const type = product.name;
      if (type === 'Reinforcement Bar') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: '6mm',
              unitOfMeasure: 'BERGA',
            },
            {
              productId: product.id,
              variant: '8mm',
              unitOfMeasure: 'BERGA',
            },
            {
              productId: product.id,
              variant: '10mm',
              unitOfMeasure: 'BERGA',
            },
            {
              productId: product.id,
              variant: '12mm',
              unitOfMeasure: 'BERGA',
            },
            {
              productId: product.id,
              variant: '14mm',
              unitOfMeasure: 'BERGA',
            },
            {
              productId: product.id,
              variant: '16mm',
              unitOfMeasure: 'BERGA',
            },
            {
              productId: product.id,
              variant: '20mm',
              unitOfMeasure: 'BERGA',
            },
            {
              productId: product.id,
              variant: '24mm',
              unitOfMeasure: 'BERGA',
            },
            {
              productId: product.id,
              variant: '32mm',
              unitOfMeasure: 'BERGA',
            },
          ],
        });
      } else if (type === 'Cement') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: 'OPC',
              unitOfMeasure: 'QUINTAL',
            },
            {
              productId: product.id,
              variant: 'PPC',
              unitOfMeasure: 'QUINTAL',
            },
          ],
        });
      } else if (type === 'Sand') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: 'Sand',
              unitOfMeasure: 'M3',
            },
          ],
        });
      } else if (type === 'Aggregate') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: '00',
              unitOfMeasure: 'M3',
            },
            {
              productId: product.id,
              variant: '02',
              unitOfMeasure: 'M3',
            },
          ],
        });
      } else if (type === 'Nail') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: '1',
              unitOfMeasure: 'PACKET',
            },
            {
              productId: product.id,
              variant: '2',
              unitOfMeasure: 'PACKET',
            },
            {
              productId: product.id,
              variant: '4',
              unitOfMeasure: 'PACKET',
            },
            {
              productId: product.id,
              variant: '6',
              unitOfMeasure: 'PACKET',
            },
            {
              productId: product.id,
              variant: '7',
              unitOfMeasure: 'PACKET',
            },
            {
              productId: product.id,
              variant: '8',
              unitOfMeasure: 'PACKET',
            },
            {
              productId: product.id,
              variant: '10',
              unitOfMeasure: 'PACKET',
            },
            {
              productId: product.id,
              variant: '12',
              unitOfMeasure: 'PACKET',
            },
            {
              productId: product.id,
              variant: '15',
              unitOfMeasure: 'PACKET',
            },
          ],
        });
      } else if (type === 'Black Wire') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: '1.5',
              unitOfMeasure: 'KG',
            },
            {
              productId: product.id,
              variant: '2.5',
              unitOfMeasure: 'KG',
            },
          ],
        });
      } else if (type === 'Block') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: '10',
              unitOfMeasure: 'PCS',
            },
            {
              productId: product.id,
              variant: '15',
              unitOfMeasure: 'PCS',
            },
            {
              productId: product.id,
              variant: '20',
              unitOfMeasure: 'PCS',
            },
          ],
        });
      } else if (type === 'Admixture') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: 'Admixture',
              unitOfMeasure: 'LITER',
            },
          ],
        });
      } else if (type === 'Wood') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: '6',
              unitOfMeasure: 'PCS',
            },
            {
              productId: product.id,
              variant: '8',
              unitOfMeasure: 'PCS',
            },
            {
              productId: product.id,
              variant: '10',
              unitOfMeasure: 'PCS',
            },
            {
              productId: product.id,
              variant: '12',
              unitOfMeasure: 'PCS',
            },
            {
              productId: product.id,
              variant: '15',
              unitOfMeasure: 'PCS',
            },
          ],
        });
      } else if (type === 'Morale') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: '5x7',
              unitOfMeasure: 'PCS',
            },
            {
              productId: product.id,
              variant: '4x5',
              unitOfMeasure: 'PCS',
            },
          ],
        });
      } else if (type === 'Bonda') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: 'Bonda',
              unitOfMeasure: 'KG',
            },
          ],
        });
      } else if (type === 'Roof') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: 'CIS',
              unitOfMeasure: 'PCS',
            },
            {
              productId: product.id,
              variant: 'Ega Sheet',
              unitOfMeasure: 'PCS',
            },
            {
              productId: product.id,
              variant: 'Decra',
              unitOfMeasure: 'PCS',
            },
          ],
        });
      } else if (type === 'Waterproof') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: 'Waterproof',
              unitOfMeasure: 'LITER',
            },
          ],
        });
      } else if (type === 'Paint') {
        await prisma.productVariant.createMany({
          data: [
            {
              productId: product.id,
              variant: 'Quartz',
              unitOfMeasure: 'PCS',
            },
            {
              productId: product.id,
              variant: 'Primer',
              unitOfMeasure: 'PCS',
            },
          ],
        });
      }
    }
    console.log('Product Variant models seeded successfully');
  } catch (error) {
    console.error('Error seeding product models:', error);
  }
}

async function seedWarehouseStores() {
  try {
    const companies = await prisma.company.findMany();
    await prisma.warehouseStore.createMany({
      data: [
        {
          name: 'Warehouse 1',
          location: 'Location 1',
          companyId: companies[0].id,
        },
        {
          name: 'Warehouse 2',
          location: 'Location 2',
          companyId: companies[0].id,
        },
        {
          name: 'Warehouse 3',
          location: 'Location 3',
          companyId: companies[1].id,
        },
        {
          name: 'Warehouse 4',
          location: 'Location 4',
          companyId: companies[1].id,
        },
        {
          name: 'Warehouse 5',
          location: 'Location 5',
          companyId: companies[2].id,
        },
        {
          name: 'Warehouse 6',
          location: 'Location 6',
          companyId: companies[2].id,
        },
      ],
    });
    console.log('WarehouseStore models seeded successfully');
  } catch (error) {
    console.error('Error seeding WarehouseStore models:', error);
  }
}

async function seedWarehouseStoreManagers() {
  const warehouseStores = await prisma.warehouseStore.findMany();
  const storeManagers = await prisma.user.findMany({
    where: {
      role: UserRole.STORE_MANAGER,
    },
  });
  try {
    for (let i = 0; i < 5; i++) {
      await prisma.warehouseStoreManager.create({
        data: {
          storeManagerId: storeManagers[i].id,
          warehouseStoreId: warehouseStores[i].id,
        },
      });
    }

    console.log('WarehouseStoreManager models seeded successfully');
  } catch (error) {
    console.error('Error seeding WarehouseStoreManager models:', error);
  }
}

async function seedWarehouseProducts() {
  try {
    const productVariants = await prisma.productVariant.findMany();
    const warehouseStores = await prisma.warehouseStore.findMany();
    const projects = await prisma.project.findMany();
    await prisma.warehouseProduct.createMany({
      data: productVariants
        .map((variant) => {
          return warehouseStores.map((warehouseStore) => {
            return {
              projectId: projects[Math.floor(Math.random() * 3)].id,
              productVariantId: variant.id,
              warehouseId: warehouseStore.id,
              quantity: Math.floor(Math.random() * 100),
              currentPrice: Math.floor(Math.random() * 100),
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
async function seedMaterialIssueVouchers() {
  let currentSerialNumber = 1;
  function generateSerialNumber(): string {
    const paddedSerialNumber =
      'ISS/' + currentSerialNumber.toString().padStart(4, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }
  const projects = await prisma.project.findMany();
  const warehouseStores = await prisma.warehouseStore.findMany();
  const store_managers = await prisma.user.findMany({
    where: { role: 'STORE_MANAGER' },
  });

  try {
    for (const project of projects) {
      const site_managers = await prisma.user.findMany({
        where: {
          role: 'SITE_MANAGER',
          ProjectUser: {
            some: {
              projectId: project.id,
            },
          },
        },
      });

      if (site_managers.length > 0 && store_managers.length > 0) {
        const issueVouchers = [
          {
            serialNumber: generateSerialNumber(),
            approvedById: store_managers[0].id,
            projectId: project.id,
            warehouseStoreId: warehouseStores[0].id,
            preparedById: site_managers[0].id,
            status: ApprovalStatus.COMPLETED,
          },
          {
            serialNumber: generateSerialNumber(),
            projectId: project.id,
            warehouseStoreId: warehouseStores[1].id,
            preparedById: site_managers[0].id,
            status: ApprovalStatus.PENDING,
          },

          {
            serialNumber: generateSerialNumber(),
            approvedById: store_managers[0].id,
            projectId: project.id,
            warehouseStoreId: warehouseStores[1].id,
            preparedById: site_managers[0].id,
            status: ApprovalStatus.DECLINED,
          },
          {
            serialNumber: generateSerialNumber(),
            approvedById: store_managers[0].id,
            projectId: project.id,
            warehouseStoreId: warehouseStores[2].id,
            preparedById: site_managers[0].id,
            status: ApprovalStatus.COMPLETED,
          },
          {
            serialNumber: generateSerialNumber(),
            projectId: project.id,
            warehouseStoreId: warehouseStores[0].id,
            preparedById: site_managers[0].id,
            status: ApprovalStatus.PENDING,
          },
          {
            serialNumber: generateSerialNumber(),
            approvedById: store_managers[1].id,
            projectId: project.id,
            warehouseStoreId: warehouseStores[2].id,
            preparedById: site_managers[0].id,
            status: ApprovalStatus.DECLINED,
          },
        ];

        for (const data of issueVouchers) {
          const warehouseProducts = await prisma.warehouseProduct.findMany({
            where: {
              projectId: project.id,
              warehouseId: data.warehouseStoreId,
            },
          });
          const items = [];
          for (const product of warehouseProducts.slice(0, 2)) {
            items.push({
              quantity: Math.floor(Math.random() * (product.quantity - 1)) + 1,
              productVariant: {
                connect: { id: product.productVariantId },
              },
              useType: UseType.SUPER_STRUCTURE,
              superStructureDescription:
                SuperStructureUseDescription.SANITARY_INSTALLATION,
              totalCost: 0,
              unitCost: product.currentPrice,
            });
          }

          for (const item of items) {
            item.totalCost = item.quantity * item.unitCost;
          }

          await prisma.materialIssueVoucher.create({
            data: {
              ...data,
              items: {
                create: items,
              },
            },
          });
        }
      }
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
      'RTN/' + currentSerialNumber.toString().padStart(4, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }
  const projects = await prisma.project.findMany();

  const store_managers = await prisma.user.findMany({
    where: { role: 'STORE_MANAGER' },
  });
  const warehouse_stores = await prisma.warehouseStore.findMany();
  const material_issues = await prisma.materialIssueVoucher.findMany({
    include: {
      items: true,
      warehouseStore: true,
    },
  });
  try {
    for (const project of projects) {
      const site_managers = await prisma.user.findMany({
        where: {
          role: 'SITE_MANAGER',
          ProjectUser: {
            some: {
              projectId: project.id,
            },
          },
        },
      });

      if (site_managers.length > 0 && store_managers.length > 0) {
        const returnVouchers = [
          {
            serialNumber: generateSerialNumber(),
            receivingWarehouseStoreId: warehouse_stores[0].id,
            projectId: project.id,
            receivedById: store_managers[0].id,
            returnedById: site_managers[0].id,
            status: ApprovalStatus.COMPLETED,
          },
          {
            serialNumber: generateSerialNumber(),
            receivingWarehouseStoreId: warehouse_stores[0].id,
            projectId: project.id,
            returnedById: site_managers[0].id,
            status: ApprovalStatus.PENDING,
          },
          {
            serialNumber: generateSerialNumber(),
            receivingWarehouseStoreId: warehouse_stores[0].id,
            projectId: project.id,
            receivedById: store_managers[0].id,
            returnedById: site_managers[0].id,
            status: ApprovalStatus.DECLINED,
          },
          {
            serialNumber: generateSerialNumber(),
            receivingWarehouseStoreId: warehouse_stores[0].id,
            projectId: project.id,
            receivedById: store_managers[0].id,
            returnedById: site_managers[0].id,
            status: ApprovalStatus.COMPLETED,
          },
          {
            serialNumber: generateSerialNumber(),
            receivingWarehouseStoreId: warehouse_stores[0].id,
            projectId: project.id,
            returnedById: site_managers[0].id,
            status: ApprovalStatus.PENDING,
          },
          {
            serialNumber: generateSerialNumber(),
            receivingWarehouseStoreId: warehouse_stores[0].id,
            projectId: project.id,
            receivedById: store_managers[1].id,
            returnedById: site_managers[0].id,
            status: ApprovalStatus.DECLINED,
          },
        ];

        const productVariants = await prisma.productVariant.findMany();

        for (const data of returnVouchers) {
          await prisma.materialReturnVoucher.create({
            data: {
              ...data,
              items: {
                create: [
                  {
                    quantity: 10,
                    issueVoucherId: material_issues[0].id,
                    productVariantId: productVariants[0].id,
                    totalCost: 500,
                    unitCost: 50,
                  },
                  {
                    quantity: 20,
                    issueVoucherId: material_issues[1].id,
                    productVariantId: productVariants[1].id,
                    totalCost: 100,
                    unitCost: 5,
                  },
                  {
                    quantity: 100,
                    issueVoucherId: material_issues[1].id,
                    productVariantId: productVariants[2].id,
                    totalCost: 150,
                    unitCost: 1.5,
                  },
                ],
              },
            },
          });
        }
      }
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
      'REC/' + currentSerialNumber.toString().padStart(4, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }
  const projects = await prisma.project.findMany({
    include: {
      ProjectUsers: true,
    },
  });
  const warehouse_stores = await prisma.warehouseStore.findMany();

  try {
    for (const project of projects) {
      const purchase_orders = await prisma.purchaseOrder.findMany({
        where: {
          projectId: project.id,
        },
        include: {
          items: true,
        },
      });

      const project_managers = await prisma.user.findMany({
        where: {
          role: 'PROJECT_MANAGER',
          ProjectUser: {
            some: {
              projectId: project.id,
            },
          },
        },
      });
      const purchasers = await prisma.user.findMany({
        where: {
          role: 'PURCHASER',
          ProjectUser: {
            some: {
              projectId: project.id,
            },
          },
        },
      });

      if (purchasers.length > 0 && project_managers.length > 0) {
        const receiveVouchers = [
          {
            serialNumber: generateSerialNumber(),
            projectId: project.id,
            approvedById: project_managers[0].id,
            preparedById: purchasers[0].id,
            warehouseStoreId: warehouse_stores[0].id,
            status: ApprovalStatus.COMPLETED,
          },
          {
            serialNumber: generateSerialNumber(),
            projectId: project.id,
            warehouseStoreId: warehouse_stores[1].id,
            preparedById: purchasers[0].id,
            status: ApprovalStatus.PENDING,
          },
          {
            serialNumber: generateSerialNumber(),
            projectId: project.id,
            warehouseStoreId: warehouse_stores[2].id,
            preparedById: purchasers[0].id,
            status: ApprovalStatus.PENDING,
          },
        ];

        for (const data of receiveVouchers) {
          const materialReceiveVoucher =
            await prisma.materialReceiveVoucher.create({
              include: {
                items: {
                  include: {
                    purchaseOrderItem: {
                      include: {
                        materialRequestItem: true,
                        proforma: {
                          include: {
                            materialRequestItem: true,
                          },
                        },
                      },
                    },
                  },
                },
              },
              data: {
                ...data,
                items: {
                  create: [
                    {
                      receivedQuantity:
                        Math.floor(
                          Math.random() *
                            (purchase_orders[0].items[1].quantity - 1),
                        ) + 1,
                      purchaseOrderItemId: purchase_orders[0].items[1].id,
                      loadingCost: 800,
                      unloadingCost: 1100,
                      transportationCost: 1500,
                    },
                    {
                      receivedQuantity:
                        Math.floor(
                          Math.random() *
                            (purchase_orders[1].items[2].quantity - 1),
                        ) + 1,
                      purchaseOrderItemId: purchase_orders[1].items[2].id,
                      loadingCost: 1200,
                      unloadingCost: 600,
                      transportationCost: 1000,
                    },
                    {
                      receivedQuantity:
                        Math.floor(
                          Math.random() *
                            (purchase_orders[2].items[0].quantity - 1),
                        ) + 1,
                      purchaseOrderItemId: purchase_orders[2].items[0].id,
                      loadingCost: 1000,
                      unloadingCost: 1000,
                      transportationCost: 2000,
                    },
                  ],
                },
              },
            });
          for (const item of materialReceiveVoucher.items) {
            if (data.status === 'COMPLETED') {
              await prisma.priceHistory.create({
                data: {
                  productVariantId:
                    item.purchaseOrderItem.materialRequestItem
                      ?.productVariantId ||
                    item.purchaseOrderItem.proforma.materialRequestItem
                      ?.productVariantId,
                  companyId: project.companyId,
                  price: item.purchaseOrderItem.unitPrice,
                },
              });
            }
          }
        }
      }
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
      'MRQ/' + currentSerialNumber.toString().padStart(4, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }
  const projects = await prisma.project.findMany();

  try {
    for (const project of projects) {
      const project_managers = await prisma.user.findMany({
        where: {
          role: 'PROJECT_MANAGER',
          ProjectUser: {
            some: {
              projectId: project.id,
            },
          },
        },
      });
      const site_managers = await prisma.user.findMany({
        where: {
          role: 'SITE_MANAGER',
          ProjectUser: {
            some: {
              projectId: project.id,
            },
          },
        },
      });

      if (site_managers.length > 0) {
        const requestVouchers = [
          {
            serialNumber: generateSerialNumber(),
            projectId: project.id,
            requestedById: site_managers[0].id,
            approvedById: project_managers[0].id,
            status: ApprovalStatus.COMPLETED,
          },
          {
            serialNumber: generateSerialNumber(),
            projectId: project.id,
            requestedById: site_managers[0].id,
            status: ApprovalStatus.PENDING,
          },
          {
            serialNumber: generateSerialNumber(),
            projectId: project.id,
            requestedById: site_managers[0].id,
            status: ApprovalStatus.PENDING,
          },
          {
            serialNumber: generateSerialNumber(),
            projectId: project.id,
            requestedById: site_managers[0].id,
            approvedById: project_managers[0].id,
            status: ApprovalStatus.DECLINED,
          },
        ];

        const productVariants = await prisma.productVariant.findMany();

        for (const data of requestVouchers) {
          await prisma.materialRequestVoucher.create({
            data: {
              ...data,
              items: {
                create: [
                  {
                    productVariantId: productVariants[0].id,
                    quantity: 100,
                    remark: 'Remark 1',
                  },
                  {
                    productVariantId: productVariants[1].id,
                    quantity: 10,
                    remark: 'Remark 2',
                  },
                  {
                    productVariantId: productVariants[2].id,
                    quantity: 10,
                    remark: 'Remark 3',
                  },
                ],
              },
            },
          });
        }
      }
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
      'PO/' + currentSerialNumber.toString().padStart(4, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }

  const projects = await prisma.project.findMany();

  try {
    for (const project of projects) {
      const project_managers = await prisma.user.findMany({
        where: {
          role: 'PROJECT_MANAGER',
          ProjectUser: {
            some: {
              projectId: project.id,
            },
          },
        },
      });
      const purchasers = await prisma.user.findMany({
        where: {
          role: 'SITE_MANAGER',
          ProjectUser: {
            some: {
              projectId: project.id,
            },
          },
        },
      });

      if (purchasers.length > 0) {
        const purchaseOrders = [
          {
            projectId: project.id,
            serialNumber: generateSerialNumber(),
            approvedById: project_managers[0].id,
            vat: 130.43,
            subTotal: 869.57,
            grandTotal: 1000,
            preparedById: purchasers[0].id,
            status: ApprovalStatus.COMPLETED,
          },
          {
            projectId: project.id,
            serialNumber: generateSerialNumber(),
            vat: 195.65,
            subTotal: 1304.35,
            grandTotal: 1500,
            preparedById: purchasers[0].id,
            status: ApprovalStatus.PENDING,
          },
          {
            projectId: project.id,
            serialNumber: generateSerialNumber(),
            vat: 260.87,
            subTotal: 1739.13,
            grandTotal: 2000,
            preparedById: purchasers[0].id,
            status: ApprovalStatus.PENDING,
          },
        ];

        const materialRequests = await prisma.materialRequestVoucher.findMany({
          where: {
            projectId: project.id,
            status: ApprovalStatus.COMPLETED,
          },
          include: {
            items: {
              include: {
                productVariant: true,
              },
            },
          },
        });

        for (const data of purchaseOrders) {
          await prisma.purchaseOrder.create({
            data: {
              ...data,
              items: {
                create: [
                  {
                    materialRequestItemId: materialRequests[0].items[0].id,
                    quantity: materialRequests[0].items[0].quantity,
                    totalPrice: materialRequests[0].items[0].quantity * 100,
                    unitPrice: 100,
                  },
                  {
                    materialRequestItemId: materialRequests[0].items[1].id,
                    quantity: materialRequests[0].items[1].quantity,
                    totalPrice: materialRequests[0].items[1].quantity * 15,
                    unitPrice: 15,
                  },
                  {
                    materialRequestItemId: materialRequests[0].items[2].id,
                    quantity: materialRequests[0].items[2].quantity,
                    totalPrice: materialRequests[0].items[2].quantity * 35,
                    unitPrice: 35,
                  },
                ],
              },
            },
          });
        }
      }
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
      'PRO/' + currentSerialNumber.toString().padStart(4, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }
  const materialRequests = await prisma.materialRequestVoucher.findMany({
    include: {
      items: {
        include: {
          productVariant: true,
        },
      },
    },
  });
  const projects = await prisma.project.findMany();

  try {
    for (const project of projects) {
      const purchasers = await prisma.user.findMany({
        where: {
          role: 'PURCHASER',
          ProjectUser: {
            some: {
              projectId: project.id,
            },
          },
        },
      });

      if (purchasers.length > 0) {
        const proformas = [
          {
            projectId: project.id,
            serialNumber: generateSerialNumber(),
            materialRequestItemId: materialRequests[0].items[0].id,
            preparedById: purchasers[0].id,
          },
          {
            projectId: project.id,
            serialNumber: generateSerialNumber(),
            materialRequestItemId: materialRequests[2].items[0].id,
            preparedById: purchasers[0].id,
          },
          {
            projectId: project.id,
            serialNumber: generateSerialNumber(),
            materialRequestItemId: materialRequests[1].items[0].id,
            preparedById: purchasers[0].id,
          },
        ];

        for (const data of proformas) {
          await prisma.proforma.create({
            data: {
              ...data,
              items: {
                create: [
                  {
                    vendor: 'Vendor 1',
                    quantity: materialRequests[0].items[0].quantity,
                    unitPrice: 20,
                    totalPrice: materialRequests[0].items[0].quantity * 20,
                    remark:
                      'Proforma for ' +
                      materialRequests[0].items[0].productVariant.variant,
                    photos: [],
                  },
                  {
                    vendor: 'Vendor 2',
                    quantity: materialRequests[2].items[0].quantity,
                    unitPrice: 10,
                    totalPrice: materialRequests[2].items[0].quantity * 10,
                    remark:
                      'Proforma for ' +
                      materialRequests[2].items[0].productVariant.variant,
                    photos: [],
                  },
                  {
                    vendor: 'Vendor 3',
                    quantity: materialRequests[1].items[0].quantity,
                    unitPrice: 5,
                    totalPrice: materialRequests[1].items[0].quantity * 5,
                    remark:
                      'Proforma for ' +
                      materialRequests[1].items[0].productVariant.variant,
                    photos: [],
                  },
                ],
              },
            },
          });
        }
      }
    }
    console.log('Proforma models seeded successfully');
  } catch (error) {
    console.error('Error seeding proforma models:', error);
  } finally {
    await prisma.$disconnect();
  }
}
async function seedMaterialTransferVouchers() {
  let currentSerialNumber = 1;
  function generateSerialNumber(): string {
    const paddedSerialNumber =
      'TN/' + currentSerialNumber.toString().padStart(4, '0');
    currentSerialNumber++;

    return paddedSerialNumber;
  }
  const projects = await prisma.project.findMany();

  try {
    for (const project of projects) {
      const warehouse_stores = await prisma.warehouseStore.findMany({
        where: {
          companyId: project.companyId,
        },
      });
      const material_receives = await prisma.materialReceiveVoucher.findMany({
        where: {
          projectId: project.id,
        },
      });

      const project_managers = await prisma.user.findMany({
        where: {
          role: 'PROJECT_MANAGER',
          ProjectUser: {
            some: {
              projectId: project.id,
            },
          },
        },
      });

      const site_managers = await prisma.user.findMany({
        where: {
          role: 'SITE_MANAGER',
          ProjectUser: {
            some: {
              projectId: project.id,
            },
          },
        },
      });

      if (site_managers.length > 0) {
        const transferVouchers = [
          {
            serialNumber: generateSerialNumber(),
            receivingWarehouseStoreId: warehouse_stores[0].id,
            sendingWarehouseStoreId: warehouse_stores[1].id,
            projectId: project.id,
            preparedById: site_managers[0].id,
            approvedById: project_managers[0].id,
            status: ApprovalStatus.COMPLETED,
            materialReceiveId: material_receives[0].id,
          },
          {
            serialNumber: generateSerialNumber(),
            receivingWarehouseStoreId: warehouse_stores[0].id,
            sendingWarehouseStoreId: warehouse_stores[1].id,
            projectId: project.id,
            preparedById: site_managers[0].id,
            status: ApprovalStatus.PENDING,
            materialReceiveId: material_receives[2].id,
          },
          {
            serialNumber: generateSerialNumber(),
            receivingWarehouseStoreId: warehouse_stores[1].id,
            sendingWarehouseStoreId: warehouse_stores[0].id,
            projectId: project.id,
            preparedById: site_managers[0].id,
            approvedById: project_managers[0].id,
            status: ApprovalStatus.COMPLETED,
            materialReceiveId: material_receives[1].id,
          },

          {
            serialNumber: generateSerialNumber(),
            receivingWarehouseStoreId: warehouse_stores[1].id,
            sendingWarehouseStoreId: warehouse_stores[0].id,
            projectId: project.id,
            preparedById: site_managers[0].id,
            approvedById: project_managers[0].id,
            status: ApprovalStatus.DECLINED,
            materialReceiveId: material_receives[1].id,
          },

          {
            serialNumber: generateSerialNumber(),
            receivingWarehouseStoreId: warehouse_stores[0].id,
            sendingWarehouseStoreId: warehouse_stores[1].id,
            projectId: project.id,
            preparedById: site_managers[0].id,
            status: ApprovalStatus.PENDING,
            materialReceiveId: material_receives[0].id,
          },

          {
            serialNumber: generateSerialNumber(),
            receivingWarehouseStoreId: warehouse_stores[0].id,
            sendingWarehouseStoreId: warehouse_stores[1].id,
            projectId: project.id,
            preparedById: site_managers[0].id,
            approvedById: project_managers[0].id,
            status: ApprovalStatus.COMPLETED,
            materialReceiveId: material_receives[0].id,
          },
        ];

        for (const data of transferVouchers) {
          const warehouseProducts = await prisma.warehouseProduct.findMany({
            where: {
              projectId: project.id,
              warehouseId: data.sendingWarehouseStoreId,
            },
          });
          const items = [];
          for (const product of warehouseProducts.slice(0, 2)) {
            items.push({
              quantityTransferred:
                Math.floor(Math.random() * (product.quantity - 1)) + 1,
              quantityRequested: 10,
              totalCost: 0,
              unitCost: product.currentPrice,
              productVariant: {
                connect: { id: product.productVariantId },
              },
            });
          }

          for (const item of items) {
            item.totalCost = item.quantityTransferred * item.unitCost;
          }

          await prisma.materialTransferVoucher.create({
            data: {
              ...data,
              items: {
                create: items,
              },
            },
          });
        }
      }
    }
    console.log('Material Transfer models seeded successfully');
  } catch (error) {
    console.error('Error seeding material transfer models:', error);
  } finally {
    await prisma.$disconnect();
  }
}

async function seedDailySiteData() {
  const projects = await prisma.project.findMany();

  try {
    for (const project of projects) {
      const consultants = await prisma.user.findMany({
        where: {
          role: 'CONSULTANT',
          ProjectUser: {
            some: {
              projectId: project.id,
            },
          },
        },
      });

      const productVariants = await prisma.productVariant.findMany();

      if (consultants.length > 0) {
        const preparedBy = consultants[0];

        await prisma.$transaction(
          async () => {
            await prisma.dailySiteData.create({
              data: {
                projectId: project.id,
                contractor: 'Contractor Contractor',
                preparedById: preparedBy.id,
                date: new Date(),
                tasks: {
                  create: [
                    {
                      description: 'Task 1',
                      executedQuantity: 100,
                      unit: UnitOfMeasure.M2,
                      laborDetails: {
                        create: [
                          {
                            trade: 'Carpenter',
                            number: 3,
                            morning: 5,
                            afternoon: 4,
                            overtime: 2,
                          },
                          {
                            trade: 'Mason',
                            number: 1,
                            morning: 3,
                            afternoon: 4,
                            overtime: 1,
                          },
                        ],
                      },
                      materialDetails: {
                        create: [
                          {
                            productVariantId: productVariants[1].id,
                            quantityUsed: 20,
                            quantityWasted: 2,
                          },
                          {
                            productVariantId: productVariants[2].id,
                            quantityUsed: 50,
                            quantityWasted: 5,
                          },
                        ],
                      },
                    },
                    {
                      description: 'Task 2',
                      executedQuantity: 200,
                      unit: UnitOfMeasure.M3,
                      laborDetails: {
                        create: [
                          {
                            trade: 'Laborer',
                            number: 5,
                            morning: 4,
                            afternoon: 2,
                            overtime: 1,
                          },
                        ],
                      },
                      materialDetails: {
                        create: [
                          {
                            productVariantId: productVariants[0].id,
                            quantityUsed: 30,
                            quantityWasted: 3,
                          },
                        ],
                      },
                    },
                  ],
                },
              },
              include: {
                tasks: {
                  include: {
                    laborDetails: true,
                    materialDetails: true,
                  },
                },
              },
            });
          },
          { timeout: 15000 },
        );
      }
    }
    console.log('Daily Site Data models seeded successfully');
  } catch (error) {
    console.error('Error seeding Daily Site Data models:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main()
  .catch((e) => console.error(e))
  .finally(async () => {
    await prisma.$disconnect();
  });
