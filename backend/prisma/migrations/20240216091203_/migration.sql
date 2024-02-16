/*
  Warnings:

  - A unique constraint covering the columns `[name,projectId]` on the table `Milestone` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name]` on the table `Project` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name,milestoneId]` on the table `Task` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Milestone_name_projectId_key" ON "Milestone"("name", "projectId");

-- CreateIndex
CREATE UNIQUE INDEX "Project_name_key" ON "Project"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Task_name_milestoneId_key" ON "Task"("name", "milestoneId");
