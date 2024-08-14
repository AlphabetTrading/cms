import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { FilterExpenseInput } from './dto/filter-expense.input';
import { FilterStockInput } from './dto/filter-stock.input';
import { Prisma } from '@prisma/client';

@Injectable()
export class StatService {
  constructor(private prisma: PrismaService) {}

  async getDashboardStats(projectId: string) {
    const project = await this.prisma.project.findUnique({
      where: { id: projectId },
    });
    const startDate = project.startDate;
    const endDate = project.endDate || new Date();
    const duration = this.calculateDuration(startDate, endDate);
    const progress = this.getMilestoneProgress(project.id);
    const expenditure = this.getProjectExpenditure(project.id);

    return {
      progress,
      duration,
      expenditure,
    };
  }

  async getDetailedExpenseStats(filterExpenseInput: FilterExpenseInput) {
    const {
      projectId,
      productType,
      productId,
      productVariantId,
      dateRange,
      filterPeriod,
    } = filterExpenseInput;

    let start: Date;
    let end: Date = new Date();

    switch (filterPeriod) {
      case 'day':
        start = new Date(end);
        start.setHours(0, 0, 0, 0);
        break;
      case 'week':
        start = new Date(end);
        start.setDate(start.getDate() - 7);
        start.setHours(0, 0, 0, 0);
        break;
      case 'month':
        start = new Date(end);
        start.setMonth(start.getMonth() - 1);
        start.setHours(0, 0, 0, 0);
        break;
      case 'year':
        start = new Date(end);
        start.setFullYear(start.getFullYear() - 1);
        start.setHours(0, 0, 0, 0);
        break;
      case 'alltime':
        start = new Date(0);
        break;
      default:
        start = dateRange?.start ? new Date(dateRange.start) : new Date(0);
        end = dateRange?.end ? new Date(dateRange.end) : new Date();
        break;
    }

    const where: Prisma.MaterialReceiveVoucherWhereInput = {
      projectId,
      status: 'COMPLETED',
      createdAt: {
        gte: start,
        lte: end,
      },
    };

    if (productVariantId) {
      where.items = {
        some: {
          purchaseOrderItem: {
            proforma: {
              materialRequestItem: {
                productVariant: {
                  id: productVariantId,
                },
              },
            },
            materialRequestItem: {
              productVariant: {
                id: productVariantId,
              },
            },
          },
        },
      };
    }

    if (productId) {
      where.items = {
        some: {
          purchaseOrderItem: {
            proforma: {
              materialRequestItem: {
                productVariant: {
                  productId,
                },
              },
            },
            materialRequestItem: {
              productVariant: {
                productId,
              },
            },
          },
        },
      };
    }

    if (productType) {
      where.items = {
        some: {
          purchaseOrderItem: {
            proforma: {
              materialRequestItem: {
                productVariant: {
                  product: {
                    productType,
                  },
                },
              },
            },
            materialRequestItem: {
              productVariant: {
                product: {
                  productType,
                },
              },
            },
          },
        },
      };
    }

    const materialReceiveVouchers =
      await this.prisma.materialReceiveVoucher.findMany({
        where,
        include: {
          Project: true,
          items: {
            include: {
              purchaseOrderItem: {
                include: {
                  proforma: {
                    include: {
                      materialRequestItem: {
                        include: {
                          productVariant: {
                            include: {
                              product: true,
                            },
                          },
                        },
                      },
                    },
                  },
                  materialRequestItem: {
                    include: {
                      productVariant: {
                        include: {
                          product: true,
                        },
                      },
                    },
                  },
                },
              },
            },
          },
        },
      });

    let totalItemCost = 0;

    for (const voucher of materialReceiveVouchers) {
      for (const item of voucher.items) {
        if (
          (!productVariantId && !productId && !productType) ||
          (productVariantId &&
            (item.purchaseOrderItem.materialRequestItem.productVariantId ||
              item.purchaseOrderItem.proforma.materialRequestItem
                .productVariantId) === productVariantId) ||
          (productId &&
            (item.purchaseOrderItem.materialRequestItem.productVariant
              .productId ||
              item.purchaseOrderItem.proforma.materialRequestItem.productVariant
                .productId) === productId) ||
          (productType &&
            (item.purchaseOrderItem.materialRequestItem.productVariant.product
              .productType ||
              item.purchaseOrderItem.materialRequestItem.productVariant.product
                .productType) === productType)
        ) {
          totalItemCost += item.purchaseOrderItem.totalPrice;
        }
      }
    }

    return totalItemCost;
  }

  async getDetailedStockStats(filterStockInput: FilterStockInput) {
    const { projectId, productVariantId, dateRange, filterPeriod } =
      filterStockInput;

    let start: Date;
    let end: Date = new Date();

    switch (filterPeriod) {
      case 'day':
        start = new Date(end);
        start.setHours(0, 0, 0, 0);
        break;
      case 'week':
        start = new Date(end);
        start.setDate(start.getDate() - 7);
        start.setHours(0, 0, 0, 0);
        break;
      case 'month':
        start = new Date(end);
        start.setMonth(start.getMonth() - 1);
        start.setHours(0, 0, 0, 0);
        break;
      case 'year':
        start = new Date(end);
        start.setFullYear(start.getFullYear() - 1);
        start.setHours(0, 0, 0, 0);
        break;
      case 'alltime':
        start = new Date(0);
        break;
      default:
        start = dateRange?.start ? new Date(dateRange.start) : new Date(0);
        end = dateRange?.end ? new Date(dateRange.end) : new Date();
        break;
    }

    const where: Prisma.DailySiteDataWhereInput = {
      projectId,
      status: 'COMPLETED',
      createdAt: {
        gte: start,
        lte: end,
      },
    };

    const materialReceiveWhere: Prisma.MaterialReceiveVoucherWhereInput = {
      projectId,
      status: 'COMPLETED',
      createdAt: {
        gte: start,
        lte: end,
      },
    };

    if (productVariantId) {
      where.tasks = {
        some: {
          materialDetails: {
            some: { productVariantId },
          },
        },
      };
    }

    const dailySiteDatas = await this.prisma.dailySiteData.findMany({
      where,
      include: {
        Project: true,
        tasks: {
          include: {
            materialDetails: {
              include: {
                productVariant: true,
              },
            },
            laborDetails: true,
          },
        },
      },
    });

    const materialReceives = await this.prisma.materialReceiveVoucher.findMany({
      where: materialReceiveWhere,
      include: {
        Project: true,
        items: {
          include: {
            purchaseOrderItem: {
              include: {
                materialRequestItem: {
                  include: {
                    productVariant: true,
                  },
                },
                proforma: {
                  include: {
                    materialRequestItem: {
                      include: {
                        productVariant: true,
                      },
                    },
                  },
                },
              },
            },
          },
        },
      },
    });

    let totalItemBought = 0;
    let totalItemLost = 0;
    let totalItemUsed = 0;
    let totalItemWasted = 0;

    for (const dailySiteData of dailySiteDatas) {
      for (const task of dailySiteData.tasks) {
        for (const material of task.materialDetails)
          if (
            !productVariantId ||
            (productVariantId && material.productVariantId === productVariantId)
          ) {
            totalItemUsed += material.quantityUsed;
            totalItemWasted += material.quantityWasted;
          }
      }
    }

    for (const materialReceive of materialReceives) {
      for (const item of materialReceive.items) {
        if (
          !productVariantId ||
          (productVariantId &&
            (item.purchaseOrderItem.materialRequestItem.productVariantId ||
              item.purchaseOrderItem.proforma.materialRequestItem
                .productVariantId) === productVariantId)
        ) {
          totalItemBought += item.purchaseOrderItem.quantity;
          totalItemLost +=
            item.purchaseOrderItem.quantity - item.receivedQuantity;
        }
      }
    }

    return {
      totalItemUsed,
      totalItemWasted,
      totalItemBought,
      totalItemLost,
    };
  }

  private calculateDuration(startDate: Date, endDate: Date) {
    const ms = endDate.getTime() - startDate.getTime();
    const days = Math.floor(ms / (24 * 60 * 60 * 1000));
    const hours = Math.floor((ms % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000));
    const minutes = Math.floor((ms % (60 * 60 * 1000)) / (60 * 1000));
    const seconds = Math.floor((ms % (60 * 1000)) / 1000);
    return { days, hours, minutes, seconds };
  }

  private async getProjectExpenditure(projectId: string) {
    const materialReceiveVouchers =
      await this.prisma.materialReceiveVoucher.findMany({
        where: { projectId, status: 'COMPLETED' },
        include: {
          items: {
            include: {
              purchaseOrderItem: true,
            },
          },
        },
      });

    let totalItemCost = 0;
    let totalLaborCost = 0;
    let totalTransportationCost = 0;

    for (const voucher of materialReceiveVouchers) {
      for (const item of voucher.items) {
        totalItemCost += item.purchaseOrderItem.totalPrice;
        totalLaborCost += item.unloadingCost + item.loadingCost;
        totalTransportationCost += item.transportationCost;
      }
    }

    const totalExpenditure =
      totalItemCost + totalLaborCost + totalTransportationCost;

    return {
      totalItemCost,
      totalLaborCost,
      totalTransportationCost,
      totalExpenditure,
    };
  }

  private async getMilestoneProgress(projectId: string) {
    const milestones = await this.prisma.milestone.findMany({
      where: { projectId },
      include: { Tasks: true },
    });
    const totalTasks = milestones.reduce(
      (acc, milestone) => acc + milestone.Tasks.length,
      0,
    );
    const completedTasks = milestones.reduce((acc, milestone) => {
      return (
        acc +
        milestone.Tasks.filter((task) => task.status === 'COMPLETED').length
      );
    }, 0);

    return totalTasks === 0 ? 0 : (completedTasks / totalTasks) * 100;
  }
}
