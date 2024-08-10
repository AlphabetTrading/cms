import 'package:flutter/material.dart';

class ModalError extends StatelessWidget {
  final String errorMessage;
  const ModalError({super.key,required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(color: Theme.of(context).colorScheme.error),
    );
  }
}
