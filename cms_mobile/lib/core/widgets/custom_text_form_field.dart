import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String? errorMessage;
  final Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool? readOnly;
  final String? initialValue;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final void Function()? onTap;

  const CustomTextFormField(
      {super.key,
      required this.label,
      this.prefixIcon,
      this.errorMessage,
      this.onChanged,
      this.validator,
      this.keyboardType,
      this.maxLines,
      this.onTap,
      this.readOnly,
      this.initialValue,
      this.controller});

  @override
  Widget build(BuildContext context) {
    // final border = OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(40),
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          readOnly: readOnly ?? false,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          maxLines: maxLines ?? 1,
          onTap:onTap,
          decoration: InputDecoration(
            // enabledBorder: border,
            // focusedBorder: border.copyWith(
            //     borderSide: BorderSide(
            //   color: Theme.of(context).primaryColor,
            // )),
            errorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            // focusedErrorBorder: OutlineInputBorder(
            //   borderSide:
            //       BorderSide(color: Theme.of(context).colorScheme.error),
            // ),

            isDense: true,
            // label: Text(label),
            // hintText: hint,
            errorText: errorMessage,
            // focusColor: colors.primary,
            prefixIcon: prefixIcon,
          
          ),
        )
      ],
    );
  }
}
