import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MaterialTransactionMaterialItem extends StatelessWidget {
  final String? iconSrc;
  final String title;
  final String subtitle;
  final onEdit;
  final onDelete;

  const MaterialTransactionMaterialItem(
      {super.key,
      this.iconSrc,
      required this.title,
      required this.subtitle,
      this.onEdit,
      this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
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
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(5),
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: iconSrc != null
              ? SvgPicture.asset(
                  iconSrc!,
                )
              : SizedBox(),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: PopupMenuButton<String>(
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              onTap: onEdit,
              child: const Text('Edit'),
            ),
            PopupMenuItem<String>(onTap: onDelete, child: const Text('Delete')),
          ],
        ),
      ),
    );
  }
}
