import 'package:flutter/material.dart';

class FormInfoItem extends StatelessWidget {
  final String title;
  final String value;
  const FormInfoItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          Text(value)
        ],
      ),
    );
  }
}
