import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final String label;
  final String? errorMessage;
  final bool enableFilter;
  final void Function(dynamic value) onSelected;
  final T? initialSelection;
  final Widget? trailingIcon;

  const CustomDropdown(
      {super.key,
      required this.dropdownMenuEntries,
      required this.enableFilter,
      required this.label,
      this.errorMessage,
      required this.onSelected,
      this.trailingIcon,
      this.initialSelection});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        DropdownMenu<T>(
          trailingIcon: trailingIcon != null
              ? Icon(Icons.local_airport)
              : Icon(Icons.arrow_drop_down),
          initialSelection: initialSelection,
          expandedInsets: EdgeInsets.zero,
          enableFilter: true,
          dropdownMenuEntries: dropdownMenuEntries,
          errorText: errorMessage,
          onSelected: onSelected,
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                errorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.error),
                ),
              ),
        )
      ],
    );
  }
}
