import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WarehouseTabScreen extends StatefulWidget {
  const WarehouseTabScreen({super.key});

  @override
  State<WarehouseTabScreen> createState() => _WarehouseTabScreenState();
}

class _WarehouseTabScreenState extends State<WarehouseTabScreen> {
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
                  height: 107,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1A80E5),
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
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '3,047,664',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
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
                    height: 150,
                    decoration: ShapeDecoration(
                      color: Color(0x110F4A84),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: Color(0x110F4A84),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              padding: EdgeInsets.all(3),
                              // child: SvgPicture.asset(
                              //   '/icons/dashboard/analytics.svg',
                              // ),
                            ),
                            Spacer(),
                            Text(
                              'View Details',
                              style: TextStyle(
                                color: Color.fromARGB(237, 41, 137, 233),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'ANALYTICS',
                          style: TextStyle(
                            color: Color(0xFF637587),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'View a breakdown of your total expense',
                          style: TextStyle(
                            color: Color(0xFF637587),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        SizedBox(
                          width: 143,
                          child: Text(
                            '3,047,664 ETB',
                            style: TextStyle(
                              color: Color(0xFF637587),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
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
                      height: 150,
                      padding: EdgeInsets.all(20),
                      decoration: ShapeDecoration(
                        color: Color(0xFF111416),
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
                                color: Colors.white.withOpacity(0.15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              padding: EdgeInsets.all(3),
                              // child: SvgPicture.asset(
                              //   '/icons/dashboard/progress.svg',
                              // ),
                            ),
                            Spacer(),
                            Text(
                              'View Details',
                              style: TextStyle(
                                color: Color.fromARGB(237, 41, 137, 233),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'PROGRESS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'View a breakdown of your total expense',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '67%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Recent Items',
                        style: TextStyle(
                          color: Color(0xFF111416),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: ShapeDecoration(
                            color: Color(0x21212144),
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return _buildRecentItem();
                    },
                  ),
                ],
              ),
            )

            // Text(
            //   'Cement',
            //   style: TextStyle(
            //     color: Color(0xFF111416),
            //     fontSize: 15,
            //
            //     fontWeight: FontWeight.w500,
            //     height: 0.11,
            //   ),
            // ),
            // Text(
            //   '-117,000',
            //   textAlign: TextAlign.right,
            //   style: TextStyle(
            //     color: Color(0xFF111416),
            //     fontSize: 13,
            //
            //     fontWeight: FontWeight.w600,
            //     height: 0.14,
            //   ),
            // ),

            // SizedBox(
            //   width: 92,
            //   height: 25,
            //   child: Text(
            //     '-35,000',
            //     textAlign: TextAlign.right,
            //     style: TextStyle(
            //       color: Color(0xFF111416),
            //       fontSize: 13,
            //
            //       fontWeight: FontWeight.w600,
            //       height: 0.14,
            //     ),
            //   ),
            // ),
            // Text(
            //   '10/02/2024',
            //   style: TextStyle(
            //     color: Color(0xFF637587),
            //     fontSize: 12,
            //
            //     fontWeight: FontWeight.w400,
            //     height: 0.15,
            //   ),
            // ),
            // Text(
            //   'Sand',
            //   style: TextStyle(
            //     color: Color(0xFF111416),
            //     fontSize: 15,
            //
            //     fontWeight: FontWeight.w500,
            //     height: 0.11,
            //   ),
            // ),
            // SizedBox(
            //   width: 92,
            //   height: 25,
            //   child: Text(
            //     '-35,000',
            //     textAlign: TextAlign.right,
            //     style: TextStyle(
            //       color: Color(0xFF111416),
            //       fontSize: 13,
            //
            //       fontWeight: FontWeight.w600,
            //       height: 0.14,
            //     ),
            //   ),
            // ),
            // Text(
            //   '10/02/2024',
            //   style: TextStyle(
            //     color: Color(0xFF637587),
            //     fontSize: 12,
            //
            //     fontWeight: FontWeight.w400,
            //     height: 0.15,
            //   ),
            // ),
            // Text(
            //   'Sand',
            //   style: TextStyle(
            //     color: Color(0xFF111416),
            //     fontSize: 15,
            //
            //     fontWeight: FontWeight.w500,
            //     height: 0.11,
            //   ),
            // ),

            // Container(
            //   width: 167,
            //   height: 153,
            //   decoration: ShapeDecoration(
            //     color: Color(0xFF111416),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            // ),
            // Container(
            //   width: 30,
            //   height: 30,
            //   decoration: ShapeDecoration(
            //     color: Color(0x110F4A84),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(5)),
            //   ),
            // ),
            // SizedBox(
            //   width: 143,
            //   child: Text(
            //     'View a breakdown of your total expense',
            //     style: TextStyle(
            //       color: Color(0xFF637587),
            //       fontSize: 10,
            //
            //       fontWeight: FontWeight.w400,
            //       height: 0,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: 143,
            //   child: Text(
            //     '3,047,664 ETB',
            //     style: TextStyle(
            //       color: Color(0xFF637587),
            //       fontSize: 13,
            //
            //       fontWeight: FontWeight.w700,
            //       height: 0,
            //     ),
            //   ),
            // ),
            // Container(
            //   width: 55,
            //   height: 6,
            //   decoration: ShapeDecoration(
            //     color: Color(0xFFEBCA33),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            // ),
            // Container(
            //   width: 24,
            //   height: 6,
            //   decoration: BoxDecoration(color: Color(0xFFA248ED)),
            // ),
            // Container(
            //   width: 41,
            //   height: 6,
            //   decoration: BoxDecoration(color: Color(0xFF53A0D6)),
            // ),
            // Container(
            //   width: 28,
            //   height: 6,
            //   decoration: ShapeDecoration(
            //     color: Color(0xFFE3594F),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.only(
            //         topRight: Radius.circular(10),
            //         bottomRight: Radius.circular(10),
            //       ),
            //     ),
            //   ),
            // ),
            // Container(
            //   width: 18,
            //   height: 18,
            //   padding: const EdgeInsets.all(1.12),
            //   clipBehavior: Clip.antiAlias,
            //   decoration: BoxDecoration(),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Container(
            //         width: 15.75,
            //         height: 15.75,
            //         child: Stack(children: []),
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   width: 30,
            //   height: 30,
            //   decoration: ShapeDecoration(
            //     color: Colors.white.withOpacity(0.15000000596046448),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(5)),
            //   ),
            // ),
            // Text(
            //   'PROGRESS',
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 11,
            //
            //     fontWeight: FontWeight.w700,
            //     height: 0.20,
            //   ),
            // ),
            // SizedBox(
            //   width: 143,
            //   child: Text(
            //     'View a breakdown of your total expense',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 10,
            //
            //       fontWeight: FontWeight.w400,
            //       height: 0,
            //     ),
            //   ),
            // ),
            // Container(
            //   width: 136.55,
            //   height: 6,
            //   decoration: ShapeDecoration(
            //     color: Color(0xFF4D4D4D),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(15),
            //     ),
            //   ),
            // ),
            // Container(
            //   width: 75.47,
            //   height: 6,
            //   decoration: ShapeDecoration(
            //     color: Color(0xFF1A80E5),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(15),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: 143,
            //   child: Text(
            //     '67%',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 13,
            //
            //       fontWeight: FontWeight.w700,
            //       height: 0,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: 92,
            //   height: 25,
            //   child: Text(
            //     '-117,000',
            //     textAlign: TextAlign.right,
            //     style: TextStyle(
            //       color: Color(0xFF111416),
            //       fontSize: 13,
            //
            //       fontWeight: FontWeight.w600,
            //       height: 0.14,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: 92,
            //   height: 25,
            //   child: Text(
            //     '-35,000',
            //     textAlign: TextAlign.right,
            //     style: TextStyle(
            //       color: Color(0xFF111416),
            //       fontSize: 13,
            //
            //       fontWeight: FontWeight.w600,
            //       height: 0.14,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: 92,
            //   height: 25,
            //   child: Text(
            //     '-35,000',
            //     textAlign: TextAlign.right,
            //     style: TextStyle(
            //       color: Color(0xFF111416),
            //       fontSize: 13,
            //
            //       fontWeight: FontWeight.w600,
            //       height: 0.14,
            //     ),
            //   ),
            // ),
            // Text(
            //   '10/02/2024',
            //   style: TextStyle(
            //     color: Color(0xFF637587),
            //     fontSize: 12,
            //
            //     fontWeight: FontWeight.w400,
            //     height: 0.15,
            //   ),
            // ),
            // Text(
            //   'Cement',
            //   style: TextStyle(
            //     color: Color(0xFF111416),
            //     fontSize: 15,
            //
            //     fontWeight: FontWeight.w500,
            //     height: 0.11,
            //   ),
            // ),
            // Text(
            //   '10/02/2024',
            //   style: TextStyle(
            //     color: Color(0xFF637587),
            //     fontSize: 12,
            //
            //     fontWeight: FontWeight.w400,
            //     height: 0.15,
            //   ),
            // ),
            // Text(
            //   'Sand',
            //   style: TextStyle(
            //     color: Color(0xFF111416),
            //     fontSize: 15,
            //
            //     fontWeight: FontWeight.w500,
            //     height: 0.11,
            //   ),
            // ),
            // Text(
            //   '10/02/2024',
            //   style: TextStyle(
            //     color: Color(0xFF637587),
            //     fontSize: 12,
            //
            //     fontWeight: FontWeight.w400,
            //     height: 0.15,
            //   ),
            // ),
            // Text(
            //   'Sand',
            //   style: TextStyle(
            //     color: Color(0xFF111416),
            //     fontSize: 15,
            //
            //     fontWeight: FontWeight.w500,
            //     height: 0.11,
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  ListTile _buildRecentItem() {
    return ListTile(
        leading: Container(
          width: 30,
          height: 30,
          decoration: ShapeDecoration(
            color: Color(0x110F4A84),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          padding: EdgeInsets.all(3),
          // child: SvgPicture.asset(
          //   '/icons/dashboard/analytics.svg',
          // ),
        ),
        title: Text(
          'Cement',
          style: TextStyle(
            color: Color(0xFF111416),
            fontSize: 15,
            fontWeight: FontWeight.w500,
            height: 0.11,
          ),
        ),
        subtitle: Text(
          '10/02/2024',
          style: TextStyle(
            color: Color(0xFF637587),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 0.15,
          ),
        ),
        trailing: Text(
          '-117,000',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color(0xFF111416),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 0.14,
          ),
        ));
  }
}
