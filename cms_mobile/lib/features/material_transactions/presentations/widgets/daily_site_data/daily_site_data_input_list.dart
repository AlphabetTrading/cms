import 'package:cms_mobile/features/material_transactions/domain/entities/daily_site_data.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_bloc.dart';
import 'package:cms_mobile/features/material_transactions/presentations/bloc/daily_site_data_local/daily_site_data_local_event.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/daily_site_data/create_daily_site_data_form.dart';
import 'package:cms_mobile/features/material_transactions/presentations/widgets/material_transaction_material_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailySiteDataInputList extends StatelessWidget {
  final List<DailySiteDataEnitity> dailySiteDatas;
  const DailySiteDataInputList({
    super.key,
    required this.dailySiteDatas,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: dailySiteDatas.length,
      itemBuilder: (context, index) {
        final dailySiteData = dailySiteDatas[index];
        final productVariant = dailySiteData.material!.productVariant;
        return MaterialTransactionMaterialItem(
          title: '${productVariant.product!.name} - ${productVariant.variant}',
          subtitle:
              'Amount: ${dailySiteData.quantity} ${dailySiteData.material!.productVariant.unitOfMeasure}',
          iconSrc: productVariant.product?.iconSrc,
          onDelete: () => BlocProvider.of<DailySiteDataLocalBloc>(context)
              .add(DeleteDailySiteDataMaterialLocal(index)),
          onEdit: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => MultiBlocProvider(
              providers: [
                // BlocProvider<DailySiteDataFormCubit>(
                //   create: (_) => DailySiteDataFormCubit(
                //     materialId: dailySiteData.material!.productVariant.id,
                //     quantity: dailySiteData.quantity,
                //     remark: dailySiteData.remark,
                //     subUseDescription: dailySiteData.subStructureDescription,
                //     superUseDescription:
                //         dailySiteData.superStructureDescription,
                //     useType: dailySiteData.useType,
                //     inStock: dailySiteData.material!.quantity,
                //   ),
                // )
              ],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CreateDailySiteDataForm(isEdit: true, index: index),
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
