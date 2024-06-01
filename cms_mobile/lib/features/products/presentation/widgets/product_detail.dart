import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final String title;
  final String value;
  const ProductDetail(
      {super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelMedium),
        Text(value, style: Theme.of(context).textTheme.bodyMedium)
      ],
    );
  }
}
