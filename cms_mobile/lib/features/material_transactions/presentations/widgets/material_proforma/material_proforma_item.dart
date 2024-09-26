import 'package:cms_mobile/features/material_transactions/domain/entities/material_proforma.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MaterialProformaItem extends StatefulWidget {
  final String? iconSrc;
  final String title;
  final String subtitle;
  final onOpen;
  final MaterialProformaItemEntity? proformaItem;
  final void Function(String?)? onChanged;
  final String? selectedMaterialProformaItem;
  const MaterialProformaItem(
      {super.key,
      this.iconSrc,
      required this.title,
      required this.subtitle,
      this.onOpen,
      this.selectedMaterialProformaItem,
      required this.onChanged,
      required this.proformaItem});

  @override
  State<MaterialProformaItem> createState() => _MaterialProformaItemState();
}

class _MaterialProformaItemState extends State<MaterialProformaItem> {
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
        leading: Radio(
            value: widget.proformaItem!.id,
            groupValue: widget.selectedMaterialProformaItem,
            onChanged: widget.onChanged),
        title: Text(widget.title),
        subtitle: Text(widget.subtitle),
        trailing: TextButton(
          onPressed: widget.onOpen,
          child: const Text(
            'View Details',
            style: TextStyle(
              color: Color(0xFF1A80E5),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0.17,
            ),
          ),
        ),
      ),
    );
  }
}
