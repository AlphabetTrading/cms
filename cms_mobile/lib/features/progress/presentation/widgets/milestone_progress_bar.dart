import 'package:flutter/material.dart';

class MilestoneProgressBar extends StatelessWidget {
  final double progress;
  const MilestoneProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          // color: Colors.red,
          // padding: const EdgeInsets.all(),
          child: SizedBox(
            width: 250,
            child: LinearProgressIndicator(
              minHeight: 6.4,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              value: progress / 100,
              backgroundColor:
                  Colors.grey[300], // Background color of the progress bar
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.blue,
              ), // Color of the progress indicator
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          "$progress%",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
