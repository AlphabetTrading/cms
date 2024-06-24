// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class CustomAppBar extends PreferredSize {
//   final GlobalKey<ScaffoldState> scaffoldKey;
//   const CustomAppBar(
//     this.scaffoldKey, {
//     super.key,
//   }) : super(
//           child: const SizedBox.shrink(),
//           preferredSize: const Size(100, 80),
//         );

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       systemOverlayStyle: const SystemUiOverlayStyle(
//         statusBarColor: Colors.white,
//         statusBarIconBrightness: Brightness.dark,
//         systemNavigationBarIconBrightness: Brightness.dark,
//       ),
//       backgroundColor: Colors.white,
//       toolbarHeight: 64,
//       elevation: 0,
//       leadingWidth: 200,
//       leading: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.only(left: 10),
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         decoration: BoxDecoration(
//           color: Color.fromARGB(236, 220, 219, 219),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: PopupMenuButton<String>(
//           offset: const Offset(0, 50),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Expanded(
//             flex: 1,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(
//                 // color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 18,
//                     backgroundColor: Colors.blue,
//                     child: Text(
//                       'B',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   SizedBox(width: 5),
//                   Text(
//                     'Bulbula'.toUpperCase(),
//                     style: TextStyle(
//                         color: const Color.fromARGB(255, 78, 79, 80),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w800),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           onSelected: (String result) {
//             if (result == 'Logout') {
//               // do something
//             }
//           },
//           itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//             // settings menu item
//             PopupMenuItem<String>(
//               value: 'Settings',
//               child: Expanded(
//                 flex: 1,
//                 child:
//                     Container(width: double.infinity, child: Text('Settings')),
//               ),
//             ),
//             const PopupMenuItem<String>(
//               value: 'Logout',
//               child: Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         PopupMenuButton<String>(
//           onSelected: (String result) {
//             if (result == 'Logout') {
//               // do something
//             }
//           },
//           itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//             // settings menu item
//             const PopupMenuItem<String>(
//               value: 'Settings',
//               child: Text('Settings'),
//             ),
//             const PopupMenuItem<String>(
//               value: 'Logout',
//               child: Text('Logout'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(64);
// }

import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/projects/presentations/widgets/project_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar extends PreferredSize {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppBar(
    this.scaffoldKey, {
    super.key,
  }) : super(
          child: const SizedBox.shrink(),
          preferredSize: const Size(100, 80),
        );

  // init state

  @override
  Widget build(BuildContext context) {
    final selectedProjectId =
        context.read<ProjectBloc>().state.selectedProjectId;
    final selectedProject = context
        .read<ProjectBloc>()
        .state
        .projects
        ?.items
        .firstWhere((element) => element.id == selectedProjectId);

    debugPrint('selectedProject: $selectedProject');
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      toolbarHeight: 64,
      leadingWidth: 200,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              // scaffoldKey.currentState!.openDrawer();
              _showCustomPopupMenu(context);
            },
            child: Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: Text(
                        'B',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      selectedProject?.name?.toUpperCase()??"N/A",
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _showCustomPopupMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const CustomPopupMenuDialog();
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
