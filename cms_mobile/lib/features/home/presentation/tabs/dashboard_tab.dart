import 'package:cms_mobile/features/home/presentation/widgets/custom_progress_bar.dart';
import 'package:cms_mobile/features/home/presentation/widgets/recent_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DashboardTabScreen extends StatefulWidget {
  const DashboardTabScreen({super.key});

  @override
  State<DashboardTabScreen> createState() => _DashboardTabScreenState();
}

class _DashboardTabScreenState extends State<DashboardTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                Positioned(
                  left: -5,
                  top: -5,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.20000000298023224),
                      shape: const OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: -20,
                  child: Container(
                    width: 81,
                    height: 81,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.20000000298023224),
                      shape: const OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  top: -10,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: Container(
                    width: 33,
                    height: 33,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.20000000298023224),
                      shape: const OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: MediaQuery.of(context).size.width - 150,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: const OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: MediaQuery.of(context).size.width / 2 - 50,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: const OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: MediaQuery.of(context).size.width / 3 - 50,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: const OvalBorder(),
                    ),
                  ),
                ),
                const Positioned(
                  top: 30,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Spent',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '3,047,664',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 170,
                    decoration: ShapeDecoration(
                      color: const Color(0x110F4A84),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: SvgPicture.asset(
                                Theme.of(context).brightness == Brightness.dark
                                    ? 'assets/icons/dashboard/dark/analytics.svg'
                                    : 'assets/icons/dashboard/light/analytics.svg',
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'View Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'ANALYTICS',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'View a breakdown of your total expense',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  height: 0, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          width: 143,
                          child: Text(
                            '3,047,664 ETB',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      height: 170,
                      padding: const EdgeInsets.all(20),
                      decoration: ShapeDecoration(
                        color: const Color(0x110F4A84),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: SvgPicture.asset(
                                Theme.of(context).brightness == Brightness.dark
                                    ? 'assets/icons/dashboard/dark/progress.svg'
                                    : 'assets/icons/dashboard/light/progress.svg',
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'View Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                          ]),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'PROGRESS',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'View a breakdown of your total expense',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    height: 0, fontWeight: FontWeight.normal),
                          ),
                          Text(
                            '68%',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const CustomProgressBar(progress: 67),
                        ],
                      )),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Recent Items',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: ShapeDecoration(
                      color: const Color(0x21212144),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(child: const Expanded(child: RecentItems())),
          ],
        ),
      ),
    );
  }
}
