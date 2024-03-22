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

import 'package:cms_mobile/features/theme/bloc/theme_bloc.dart';
import 'package:cms_mobile/features/theme/bloc/theme_state.dart';
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

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                    const SizedBox(width: 5),
                    Text(
                      'Bulbula'.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge,
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
        return CustomPopupMenuDialog();
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class CustomPopupMenuDialog extends StatefulWidget {
  @override
  State<CustomPopupMenuDialog> createState() => _CustomPopupMenuDialogState();
}

class _CustomPopupMenuDialogState extends State<CustomPopupMenuDialog> {
  final List<String> _projects = ['Bulbula', '24', 'Kazanchis'];

  // selected project index
  int _selectedProjectIndex = 0;

  void _onProjectSelected(int index) {
    setState(() {
      _selectedProjectIndex = index;
    });
  }

  // dark mode switch
  // bool _darkMode = false;

  // void _onDarkModeSwitch(bool value) {
  //   setState(() {
  //     _darkMode = value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.grey[300],
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Projects',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: _projects.map((project) {
                      bool selected =
                          _projects.indexOf(project) == _selectedProjectIndex;
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // color: selected ? Theme.of(context).colorScheme.surfaceVariant : Theme.of(context).colorScheme.surface,
                        ),
                        child: ListTile(
                          onTap: () {
                            _onProjectSelected(_projects.indexOf(project));
                          },
                          selected: selected,
                          selectedTileColor: Colors.grey[300],
                          leading: CircleAvatar(
                              radius: 15,
                              child:
                                  Text(project.substring(0, 1).toUpperCase())),
                          title: Text(
                            project.toUpperCase(),
                            // style: const TextStyle(
                            //     fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          trailing: selected
                              ? const Icon(Icons.check)
                              : const SizedBox.shrink(),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  const Divider(),
                  BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
                    bool darkMode =
                        state.themeData.brightness == Brightness.dark;
                    return ListTile(
                      leading: Icon(
                        darkMode ? Icons.dark_mode : Icons.light_mode,
                      ),
                      title: Text('Switch to Dark Mode'),
                      trailing: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Switch(
                          splashRadius: 10,
                          value: darkMode,
                          onChanged: (value) {
                            if (value) {
                              themeBloc.add(ThemeEvent.toggleDark);
                            } else {
                              themeBloc.add(ThemeEvent.toggleLight);
                            }
                          },
                        ),
                      ),
                    );
                  }),
                  const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
