import 'package:cms_mobile/features/items/domain/entities/item.dart';
import 'package:cms_mobile/features/items/presentation/widgets/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemTile extends StatelessWidget {
  final WarehouseItemEntity warehouseItemEntity;
  const ItemTile({super.key, required this.warehouseItemEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
        color: const Color(0x110F4A84),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(5),
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: warehouseItemEntity.itemVariant.item?.iconSrc != null
                ? SvgPicture.asset(
                   warehouseItemEntity.itemVariant.item!.iconSrc!,
                  )
                : const SizedBox(),
          ),
          title: Text('${warehouseItemEntity.itemVariant.item!.name} ${warehouseItemEntity.itemVariant.variant}'),
          subtitle: Text(warehouseItemEntity.quantity.toString()),
          trailing: TextButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => Padding(
                padding: EdgeInsets.all(32.0),
                child: Wrap(children: [
                  Column(
                    children: [
                      ItemDetail(
                          title: "Name", value:'${warehouseItemEntity.itemVariant.item!.name} ${warehouseItemEntity.itemVariant.variant}'),
                      const SizedBox(
                        height: 10,
                      ),
                      ItemDetail(
                          title: "Quantity",
                          value: warehouseItemEntity.quantity.toString()),
                      const SizedBox(
                        height: 10,
                      ),
                      // itemDetailItem(
                      //     title: "Unit", value: itemEntity.unit),
                    ],
                  )
                ]),
              ),
            ),
            child: Text(
              "View More",
              style: TextStyle(fontSize: 12),
            ),
          )),
    );
  }
}
