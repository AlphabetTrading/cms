import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cms_mobile/features/material_transactions/domain/entities/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/details/details_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/details/generate_pdf_cubit.dart';
import 'package:cms_mobile/core/entities/pagination.dart';
import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:cms_mobile/core/widgets/status_message.dart';
import 'package:cms_mobile/features/authentication/domain/entities/user_entity.dart';
import 'package:cms_mobile/features/authentication/presentations/bloc/auth/auth_bloc.dart';
import 'package:cms_mobile/features/material_transactions/data/data_source/material_issues/material_issue_remote_data_source.dart';
import 'package:cms_mobile/features/material_transactions/data/models/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issues/material_issues_state.dart';
import 'package:cms_mobile/features/material_transactions/presentations/utils/use_type.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/transaction_info_item.dart';
import 'package:cms_mobile/features/products/presentation/utils/unit_of_measure.dart';
import 'package:cms_mobile/features/products/presentation/widgets/product_detail.dart';
import 'package:cms_mobile/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';

class MaterialIssueDetailsPage extends StatefulWidget {
  final String materialIssueId;
  const MaterialIssueDetailsPage({super.key, required this.materialIssueId});
  @override
  State<MaterialIssueDetailsPage> createState() =>
      _MaterialIssueDetailsPageState();
}

Future<void> saveAndOpenPdf(String base64String) async {
  try {
    Uint8List bytes = base64Decode(base64String);

    final directory = await getTemporaryDirectory();
    final path =
        '${directory.path}/Material Issue.pdf';

    final file = File(path);
    await file.writeAsBytes(bytes);

    await OpenFile.open(path);
  } catch (e) {
    print('Error: $e');
  }
}

class _MaterialIssueDetailsPageState extends State<MaterialIssueDetailsPage> {
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<MaterialIssueBloc>(context).add(
    //     GetMaterialIssueDetailsEvent(materialIssueId: widget.materialIssueId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<MaterialIssueDetailsCubit>()
            ..onGetMaterialIssueDetails(
                materialIssueId: widget.materialIssueId),
        ),
        BlocProvider(create: (context) => sl<MaterialIssueGeneratePdfCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Material Issue Details"),
          actions: [
            BlocConsumer<MaterialIssueGeneratePdfCubit,
                MaterialIssueGeneratePdfState>(
              listener: (context, state) {
                if (state is MaterialIssueGeneratePdfSuccess) {
                  // Show success message and handle PDF opening
                  Fluttertoast.showToast(
                    msg: "PDF download started",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                  // Open or save PDF as required
                  saveAndOpenPdf(state.materialIssue);
                } else if (state is MaterialIssueGeneratePdfFailed) {
                  // Show error message
                  Fluttertoast.showToast(
                    msg: "Failed to generate PDF: ${state.error}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              builder: (context, state) {
                // Popup menu with the option to generate PDF
                return PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'generate_pdf') {
                      // Trigger PDF generation
                      context
                          .read<MaterialIssueGeneratePdfCubit>()
                          .onGetMaterialIssueGeneratePdf(
                              materialIssueId: widget.materialIssueId);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'generate_pdf',
                      child: Text('Generate PDF'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        
        body: BlocBuilder<MaterialIssueDetailsCubit, MaterialIssueDetailsState>(
          builder: (context, state) {
            if (state is MaterialIssueDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MaterialIssueDetailsFailed) {
              return Text(state.error);
            } else if (state is MaterialIssueDetailsSuccess) {
              final materialIssue = state.materialIssue;
              final project = materialIssue?.project;
              final preparedBy = materialIssue?.preparedBy;
              final approvedBy = materialIssue?.approvedBy;
              final materialIssueMaterials = materialIssue?.items ?? [];
              final authUser = context.read<AuthBloc>().state.user;

              final isSpecificUser = authUser?.role == UserRole.STORE_MANAGER;
              final isPending = materialIssue?.status == "PENDING";

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildMaterialIssueInfo(context, materialIssue, project,
                        preparedBy, approvedBy),
                    const SizedBox(height: 24),
                    buildMaterialIssueMaterialsList(
                        context, materialIssueMaterials),
                    const SizedBox(height: 20),
                    BlocListener<MaterialIssueBloc, MaterialIssueState>(
                        listener: (context, state) {
                          if (state is ApproveMaterialIssueSuccess) {
                            showStatusMessage(Status.SUCCESS,
                                "Successfully updated material issue status");
                            context.goNamed(RouteNames.materialIssue);

                            BlocProvider.of<MaterialIssueBloc>(context).add(
                              GetMaterialIssues(
                                filterMaterialIssueInput:
                                    FilterMaterialIssueInput(),
                                orderBy: OrderByMaterialIssueInput(
                                    createdAt: "desc"),
                                paginationInput:
                                    PaginationInput(skip: 0, take: 20),
                                mine: false,
                              ),
                            );
                          } else if (state is ApproveMaterialIssueFailed) {
                            showStatusMessage(
                                Status.FAILED, state.error?.errorMessage ?? "");
                          }
                        },
                        child: buildApproveDeclineSection(
                            context, isPending, materialIssue, state)),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

Widget buildMaterialIssueInfo(
    BuildContext context, materialIssue, project, preparedBy, approvedBy) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Issue Info",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const Expanded(
            child: Divider(),
          )
        ],
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TransactionInfoItem(
                title: 'Project', value: project?.name ?? 'N/A'),
            const SizedBox(height: 12),
            TransactionInfoItem(
                title: 'Material Issue Number',
                value: materialIssue?.serialNumber ?? 'N/A'),
            const SizedBox(height: 12),
            TransactionInfoItem(
                title: 'Prepared by', value: preparedBy?.fullName ?? 'N/A'),
            const SizedBox(height: 12),
            TransactionInfoItem(
                title: 'Date',
                value: materialIssue?.createdAt != null
                    ? DateFormat('MMMM dd, yyyy HH:mm')
                        .format(materialIssue!.createdAt!)
                    : 'N/A'),
            const SizedBox(height: 12),
            TransactionInfoItem(
                title: 'Status', value: materialIssue?.status ?? 'N/A'),
            const SizedBox(height: 12),
            TransactionInfoItem(
                title: 'Approved by', value: approvedBy?.fullName ?? 'N/A'),
          ],
        ),
      ),
    ],
  );
}

Widget buildMaterialIssueMaterialsList(
    BuildContext context, materialIssueMaterials) {
  return Expanded(
      child: Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Materials List",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const Expanded(
            child: Divider(),
          )
        ],
      ),
      const SizedBox(height: 24),
      Expanded(
        child: ListView.builder(
          itemCount: materialIssueMaterials.length,
          itemBuilder: (context, index) {
            final materialIssueMaterial = materialIssueMaterials[index];
            final productVariant = materialIssueMaterial.productVariant;
            return MaterialTransactionMaterialItem(
              title:
                  '${productVariant?.product?.name} - ${productVariant?.variant}',
              subtitle:
                  'Issued Quantity: ${materialIssueMaterial.quantity} ${unitOfMeasureDisplay(productVariant?.unitOfMeasure)}',
              iconSrc: 'assets/icons/transactions/light/material_issues.svg',
              onDelete: () {},
              onEdit: () {},
              onOpen: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Wrap(children: [
                      Column(
                        children: [
                          ProductDetail(
                              title: "Name",
                              value:
                                  '${productVariant?.product?.name} - ${productVariant?.variant}'),
                          const SizedBox(
                            height: 10,
                          ),
                          ProductDetail(
                              title: "Use Type",
                              value: useTypeDisplay[
                                      materialIssueMaterial.useType] ??
                                  'N/A'),
                          const SizedBox(
                            height: 10,
                          ),
                          materialIssueMaterial.useType == UseType.SUB_STRUCTURE
                              ? ProductDetail(
                                  title: "Use Description",
                                  value: subStructureUseDescriptionDisplay[
                                          materialIssueMaterial
                                              .subStructureDescription] ??
                                      'N/A')
                              : ProductDetail(
                                  title: "Use Description",
                                  value: superStructureUseDescriptionDisplay[
                                          materialIssueMaterial
                                              .superStructureDescription] ??
                                      'N/A'),
                          const SizedBox(
                            height: 10,
                          ),
                          ProductDetail(
                              title: "Issued Quantity",
                              value:
                                  '${materialIssueMaterial.quantity} ${productVariant?.unitOfMeasure}'),
                          const SizedBox(
                            height: 10,
                          ),
                          ProductDetail(
                              title: "Unit Cost",
                              value:
                                  '${materialIssueMaterial.unitCost.toString()} ETB'),
                          const SizedBox(
                            height: 10,
                          ),
                          ProductDetail(
                              title: "Total Cost",
                              value:
                                  '${materialIssueMaterial.totalCost.toString()} ETB'),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ]),
                  ),
                );
              },
            );
          },
        ),
      ),
    ],
  ));
}

Widget buildApproveDeclineSection(
    BuildContext context, isPending, materialIssue, state) {
  return Column(
    children: [
      if (isPending)
        ElevatedButton(
          onPressed: state is ApproveMaterialIssueLoading
              ? null
              : () {
                  BlocProvider.of<MaterialIssueBloc>(context).add(
                    ApproveMaterialIssueEvent(
                      ApproveMaterialIssueStatus.completed,
                      materialIssue?.id ?? "",
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state is ApproveMaterialIssueLoading
                  ? const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          )),
                    )
                  : const SizedBox(),
              const Text('Approve'),
            ],
          ),
        ),
      const SizedBox(height: 10),
      if (isPending)
        OutlinedButton(
          onPressed: state is ApproveMaterialIssueLoading
              ? null
              : () {
                  BlocProvider.of<MaterialIssueBloc>(context).add(
                    ApproveMaterialIssueEvent(
                      ApproveMaterialIssueStatus.declined,
                      materialIssue?.id ?? "",
                    ),
                  );
                },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            side: const BorderSide(color: Colors.red),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              state is ApproveMaterialIssueLoading
                  ? const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          )),
                    )
                  : const SizedBox(),
              const Text(
                'Decline',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
    ],
  );
}
