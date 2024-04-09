import 'package:cms_mobile/features/items/domain/entities/item.dart';
import 'package:cms_mobile/features/items/presentation/widgets/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemTile extends StatelessWidget {
  final ItemEntity itemEntity;
  const ItemTile({super.key, required this.itemEntity});

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
            child: itemEntity.iconSrc != null
                ? SvgPicture.asset(
                    itemEntity.iconSrc!,
                  )
                : const SizedBox(),
          ),
          title: Text(itemEntity.name),
          subtitle: Text(itemEntity.quantity.toString()),
          trailing: TextButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => Padding(
                padding: EdgeInsets.all(32.0),
                child: Wrap(children: [
                  Column(
                    children: [
                      ItemDetail(
                          title: "Name", value: itemEntity.name),
                      const SizedBox(
                        height: 10,
                      ),
                      ItemDetail(
                          title: "Quantity",
                          value: itemEntity.quantity.toString()),
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
