import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: SvgPicture.asset(
              Theme.of(context).brightness == Brightness.light
                  ? 'assets/icons/transactions/light/empty.svg'
                  : 'assets/icons/transactions/dark/empty.svg',
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
                'There are currently no materials. You can add materials by clicking the button below.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontWeight: FontWeight.w300)),
          ),
        ],
      ),
    );
  }
}
