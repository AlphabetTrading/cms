import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { ApprovalStatus, Prisma, UserRole } from '@prisma/client';
import { DailySiteData } from './model/daily-site-data.model';
import { CreateDailySiteDataInput } from './dto/create-daily-site-data.input';
import { CreateDailySiteDataTaskLaborInput } from './dto/create-daily-site-data-task-labor.input';
import { CreateDailySiteDataTaskMaterialInput } from './dto/create-daily-site-data-task-material.input';
import { UpdateDailySiteDataInput } from './dto/update-daily-site-data.input';
import { DocumentType } from 'src/common/enums/document-type';
import * as pdf from 'html-pdf';
import { format } from 'date-fns';
import { DocumentTransaction } from 'src/document-transaction/model/document-transaction-model';

@Injectable()
export class DailySiteDataService {
  constructor(private prisma: PrismaService) {}

  async createDailySiteData(
    createDailySiteDataInput: CreateDailySiteDataInput,
  ): Promise<DailySiteData> {
    return await this.prisma.$transaction(async (prisma) => {
      const createdDailySiteData = await prisma.dailySiteData.create({
        data: {
          ...createDailySiteDataInput,
          tasks: {
            create: createDailySiteDataInput.tasks.map((task) => ({
              ...task,
              laborDetails: {
                create: task.laborDetails.map(
                  (labor: CreateDailySiteDataTaskLaborInput) => ({
                    ...labor,
                  }),
                ),
              },
              materialDetails: {
                create: task.materialDetails.map(
                  (material: CreateDailySiteDataTaskMaterialInput) => ({
                    ...material,
                  }),
                ),
              },
            })),
          },
        },
        include: {
          tasks: {
            include: {
              laborDetails: true,
              materialDetails: true,
            },
          },
          Project: true,
          approvedBy: true,
          checkedBy: true,
          preparedBy: true,
        },
      });
      return createdDailySiteData;
    });
  }

  async getDailySiteDatas({
    skip,
    take,
    where,
    orderBy,
  }: {
    skip?: number;
    take?: number;
    where?: Prisma.DailySiteDataWhereInput;
    orderBy?: Prisma.DailySiteDataOrderByWithRelationInput;
  }): Promise<DailySiteData[]> {
    const dailySiteDatas = await this.prisma.dailySiteData.findMany({
      skip,
      take,
      where,
      orderBy,
      include: {
        tasks: {
          include: {
            laborDetails: true,
            materialDetails: {
              include: {
                productVariant: true,
              },
            },
          },
        },
        Project: true,
        approvedBy: true,
        checkedBy: true,
        preparedBy: true,
      },
    });
    return dailySiteDatas;
  }

  async getDailySiteDataCountByStatus({
    where,
  }: {
    where?: Prisma.DailySiteDataWhereInput;
  }): Promise<any> {
    const statusCounts = await this.prisma.dailySiteData.groupBy({
      by: ['status'],
      where,
      _count: {
        status: true,
      },
    });

    let counts = { COMPLETED: 0, DECLINED: 0, PENDING: 0 };

    counts = statusCounts.reduce((acc, { status, _count }) => {
      acc[status] = _count.status;
      return acc;
    }, counts);

    const documentTransaction = new DocumentTransaction();
    documentTransaction.approvedCount = counts.COMPLETED;
    documentTransaction.declinedCount = counts.DECLINED;
    documentTransaction.pendingCount = counts.PENDING;
    documentTransaction.type = DocumentType.DAILY_SITE_DATA;

    return documentTransaction;
  }

  async getDailySiteDataById(
    dailySiteDataId: string,
  ): Promise<DailySiteData | null> {
    const dailySiteData = await this.prisma.dailySiteData.findUnique({
      where: { id: dailySiteDataId },
      include: {
        tasks: {
          include: {
            laborDetails: true,
            materialDetails: {
              include: {
                productVariant: true,
              },
            },
          },
        },
        Project: true,
        approvedBy: true,
        checkedBy: true,
        preparedBy: true,
      },
    });

    return dailySiteData;
  }

  async updateDailySiteData(
    input: UpdateDailySiteDataInput,
  ): Promise<DailySiteData> {
    const { id: dailySiteDataId, tasks, ...dailySiteDataInput } = input;

    return await this.prisma.$transaction(async (prisma) => {
      const existingDailySiteData = await prisma.dailySiteData.findUnique({
        where: { id: dailySiteDataId },
      });

      if (!existingDailySiteData) {
        throw new NotFoundException('Daily Site Data not found');
      }

      const taskUpdateConditions = tasks.map((task) => ({
        id: task.id,
      }));

      const updateData = {
        ...dailySiteDataInput,
        tasks: {
          updateMany: tasks?.map((task) => ({
            where: {
              OR: taskUpdateConditions,
            },
            data: {
              ...task,
              laborDetails: task.laborDetails
                ? {
                    updateMany: task.laborDetails.map((labor) => ({
                      where: { id: labor.id },
                      data: labor,
                    })),
                  }
                : undefined,
              materialDetails: task.materialDetails
                ? {
                    updateMany: task.materialDetails.map((material) => ({
                      where: { id: material.id },
                      data: material,
                    })),
                  }
                : undefined,
            },
          })),
        },
      };

      const updatedDailySiteData = await prisma.dailySiteData.update({
        where: { id: dailySiteDataId },
        data: updateData,
        include: {
          tasks: {
            include: {
              laborDetails: true,
              materialDetails: {
                include: {
                  productVariant: true,
                },
              },
            },
          },
          Project: true,
          approvedBy: true,
          checkedBy: true,
          preparedBy: true,
        },
      });
      return updatedDailySiteData;
    });
  }

  async deleteDailySiteData(dailySiteDataId: string): Promise<DailySiteData> {
    const existingDailySiteData = await this.prisma.dailySiteData.findUnique({
      where: { id: dailySiteDataId },
    });

    if (!existingDailySiteData) {
      throw new NotFoundException('Daily Site Data not found');
    }

    await this.prisma.dailySiteData.delete({
      where: { id: dailySiteDataId },
    });

    return existingDailySiteData;
  }

  async getDailySiteDataApprovers(projectId?: string) {
    const approvers = await this.prisma.project.findMany({
      where: {
        id: projectId,
      },
      select: {
        ProjectUsers: {
          where: {
            user: {
              role: UserRole.PROJECT_MANAGER,
            },
          },
          select: {
            userId: true,
          },
        },
      },
    });
    return approvers;
  }

  async approveDailySiteData(
    dailySiteDataId: string,
    userId: string,
    status: ApprovalStatus,
  ): Promise<DailySiteData> {
    const dailySiteData = await this.prisma.dailySiteData.findUnique({
      where: { id: dailySiteDataId },
    });

    if (!dailySiteData) {
      throw new NotFoundException('Daily Site Data not found');
    }

    if (dailySiteData.approvedById) {
      throw new NotFoundException('Already decided on this daily site data!');
    }

    const updatedDailySiteData = await this.prisma.dailySiteData.update({
      where: { id: dailySiteDataId },
      data: {
        approvedById: userId,
        status: status,
      },
    });

    return updatedDailySiteData;
  }

  async count(where?: Prisma.DailySiteDataWhereInput): Promise<number> {
    return this.prisma.dailySiteData.count({ where });
  }

  async generatePdf(dailySiteDataId: string): Promise<string> {
    const dailySiteData = await this.prisma.dailySiteData.findUnique({
      where: { id: dailySiteDataId },
      include: {
        tasks: {
          include: {
            laborDetails: true,
            materialDetails: {
              include: {
                productVariant: {
                  include: {
                    product: true
                  }
                },
              },
            },
          },
        },
        Project: true,
        approvedBy: true,
        checkedBy: true,
        preparedBy: true,
      },
    });

    const htmlContent = this.getHtmlContent(dailySiteData);
    
    return new Promise<string>((resolve, reject) => {
      pdf.create(htmlContent).toBuffer((err, buffer) => {
        if (err) {
          reject(err);
        } else {
          resolve(buffer.toString('base64'));
        }
      });
    });
  }

  private getHtmlContent(dailySiteData: DailySiteData): string {
    return `
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Daily Site Data</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #fff;}
          .voucher { padding: 20px; margin: auto; }
          .header { text-align: center; margin-bottom: 20px; }
          .header h1 { margin: 0; font-size: 24px; text-transform: uppercase; }
          .header h2 { margin: 0; font-size: 20px; text-transform: uppercase; }
          .header-details { display: flex; justify-content: space-between; margin-top: 10px; }
          .header-details div { display: flex; flex-direction: column; align-items: flex-start; }
          .header-details div label { font-weight: bold; }
          .header-details div span { margin-top: 5px; }
          .details-left { display: flex; flex-direction: column; gap: 10px; }
          .details-right { display: flex; flex-direction: column; gap: 10px; }
          .from-to { display: flex; justify-content: space-between; margin: 20px 0; }
          .from-to div { display: flex; flex-direction: column; }
          .from-to div label { font-weight: bold; }
          .from-to div span { margin-top: 5px; }
          table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
          table th, table td { border: 1px solid #000; padding: 6px; font-size: 12px; text-align: center; }
          .task-table { width: 100%; border-collapse: collapse; }
          .task-table th, .task-table td { border: 1px solid #000; padding: 5px; font-size: 10px; text-align: center; }
          .task-table th { background-color: #f2f2f2; }
          .task-table .section-header { background-color: #e0e0e0; font-weight: bold; }
          .col-time { width: 5%; }
          .col-description { width: 30%; }
          .col-uom { width: 10%; }
          .col-quantity { width: 10%; }
          .col-cost { width: 15%; }
          .col-cost-money{ width: 10%; }
          .col-cost-cent{ width: 5%; }
          .col-remark { width: 12%; }

          .approval { display: flex; justify-content: space-between; margin-bottom: 20px; }
          .approval-section { display: flex; flex-direction: column; align-items: flex-start; }
          .approval-section label { font-weight: bold; }
          .approval-section span { margin-top: 5px; }
          .footer { margin-top: 20px; display: flex; flex-direction: column; }
          .footer label { font-weight: bold; }
          .footer span { margin-top: 5px; }
      </style>
    </head>
    <body>
      <div
        style="
          display: flex;
          flex-direction: row;
          justify-content: center;
          margin-top: 40px;
        "
      >
        <div
          style="
            display: flex;
            width: 100%;
            justify-content: center;
            align-items: center;
          "
        >
          <div style="width: 100%" class="voucher">
            <div class="header">
              <h1>Lucid Real Estate</h1>
              <h2>Daily Site Data Report</h2>
              <div class="header-details">
                <div class="details-left">
                  <div>
                    <label>Contractor:</label>
                    <span id="reference-no">${dailySiteData.contractor}</span>
                  </div>
                </div>
                <div class="details-right">
                  <div>
                    <label>Date:</label>
                    <span id="date">${format(dailySiteData.createdAt, 'MMM dd, yyyy')}</span>
                  </div>
                </div>
              </div>
            </div>
            <table class="task-table">
              <thead>
                <tr>
                  <th rowspan="3">TASK</th>
                  <th rowspan="3">Executed Qty</th>
                  <th rowspan="3">Unit</th>
                  <th colspan="5">LABOUR</th>
                  <th colspan="3">MATERIAL</th>
                </tr>
                <tr>
                  <th rowspan="2">Trade</th>
                  <th rowspan="2">Number</th>
                  <th colspan="3">Time (Hrs)</th>
                  <th rowspan="2">Type</th>
                  <th rowspan="2">Used</th>
                  <th rowspan="2">Wasted</th>
                </tr>
                <tr>
                  <th>Morning</th>
                  <th>Afternoon</th>
                  <th>Overtime</th>
                </tr>
              </thead>
              <tbody>
                ${dailySiteData.tasks
                  .map((task) => {
                    const laborRows = task.laborDetails.length;
                    const materialRows = task.materialDetails.length;
                    const maxRows = Math.max(laborRows, materialRows);
                    return Array.from({ length: maxRows })
                      .map(
                        (_, rowIndex) => `
                        <tr>
                          ${
                            rowIndex === 0
                              ? `
                            <td rowspan="${maxRows}">${task.description}</td>
                            <td rowspan="${maxRows}">${task.executedQuantity}</td>
                            <td rowspan="${maxRows}">${task.unit}</td>
                          `
                              : ''
                          }
                          <td>${task.laborDetails[rowIndex] ? task.laborDetails[rowIndex].trade : ''}</td>
                          <td>${task.laborDetails[rowIndex] ? task.laborDetails[rowIndex].number : ''}</td>
                          <td class="col-time">${task.laborDetails[rowIndex] ? task.laborDetails[rowIndex].morning : ''}</td>
                          <td class="col-time">${task.laborDetails[rowIndex] ? task.laborDetails[rowIndex].afternoon : ''}</td>
                          <td class="col-time">${task.laborDetails[rowIndex] ? task.laborDetails[rowIndex].overtime : ''}</td>
                          <td>${task.materialDetails[rowIndex] ? task.materialDetails[rowIndex].productVariant.variant + " " + task.materialDetails[rowIndex].productVariant.product.name : ''}</td>
                          <td>${task.materialDetails[rowIndex] ? task.materialDetails[rowIndex].quantityUsed : ''}</td>
                          <td>${task.materialDetails[rowIndex] ? task.materialDetails[rowIndex].quantityWasted : ''}</td>
                        </tr>
                      `,
                      )
                      .join('');
                  })
                  .join('')}
              </tbody>
            </table>
            <div class="approval">
              <div class="approval-section">
                <label>Prepared By:</label>
                <span id="requested-by">${dailySiteData.preparedBy.fullName}</span>
              </div>
              <div class="approval-section">
                <label>Checked By:</label>
                <span id="requested-by">${dailySiteData.checkedBy ? dailySiteData.checkedBy.fullName : 'N/A'}</span>
              </div>

              <div class="approval-section">
                <label>Approved By:</label>
                <span id="approved-by">${dailySiteData.approvedBy ? dailySiteData.approvedBy.fullName : 'N/A'}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </body>
  </html>
    `;
  }
}
