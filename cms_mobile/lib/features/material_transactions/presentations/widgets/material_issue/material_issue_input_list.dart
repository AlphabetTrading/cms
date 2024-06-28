import 'package:cms_mobile/features/material_transactions/domain/entities/material_issue.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/material_issue_local/material_issue_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/cubit/material_issue_form/material_issue_form_cubit.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_issue/create_material_issue_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialIssueInputList extends StatelessWidget {
  final List<MaterialIssueMaterialEntity> materialIssues;
  const MaterialIssueInputList({
    super.key,
    required this.materialIssues,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: materialIssues.length,
      itemBuilder: (context, index) {
        final materialIssue = materialIssues[index];
        final productVariant = materialIssue.material!.productVariant;
        return MaterialTransactionMaterialItem(
          title: '${productVariant.product!.name} - ${productVariant.variant}',
          subtitle:
              'Amount: ${materialIssue.quantity} ${materialIssue.material!.productVariant.unitOfMeasure}',
          iconSrc: productVariant.product?.iconSrc,
          onDelete: () => BlocProvider.of<MaterialIssueLocalBloc>(context)
              .add(DeleteMaterialIssueMaterialLocal(index)),
          onEdit: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<MaterialIssueFormCubit>(
                  create: (_) => MaterialIssueFormCubit(
                    materialId: materialIssue.material!.productVariant.id,
                    quantity: materialIssue.quantity,
                    remark: materialIssue.remark,
                    subUseDescription: materialIssue.subStructureDescription,
                    superUseDescription:
                        materialIssue.superStructureDescription,
                    useType: materialIssue.useType,
                    inStock: materialIssue.material!.quantity,
                  ),
                )
              ],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CreateMaterialIssueForm(isEdit: true, index: index),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
