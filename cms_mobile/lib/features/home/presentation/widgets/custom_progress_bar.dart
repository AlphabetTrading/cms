import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress;

  const CustomProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Expanded(
        flex: 1,
        child: Container(
          height: 2,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            widthFactor: progress / 100,
            heightFactor: 1,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
