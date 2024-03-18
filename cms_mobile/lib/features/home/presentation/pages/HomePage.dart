import 'package:cms_mobile/features/home/presentation/tabs/dashboard_tab.dart';
import 'package:cms_mobile/features/home/presentation/tabs/requests.dart';
import 'package:cms_mobile/features/home/presentation/tabs/settings.dart';
import 'package:cms_mobile/features/home/presentation/tabs/warehouse.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _onRefresh() async {}
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Create a key
  final PersistentTabController _persistentTabController =
      PersistentTabController(initialIndex: 1);

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: BlurredDrawer(),
      appBar: AppBar(
        title: const Text('CMS Mobile'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // do something
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // do something
            },
          ),
          // settings popup menu
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'Logout') {
                // do something
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              // settings menu item
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],

        // styling
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      drawerDragStartBehavior: DragStartBehavior.start,
      key: _scaffoldKey,

      body: SafeArea(
        child: _buildScreen(selectedIndex: _selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warehouse_outlined),
            label: 'Warehouse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page_outlined),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}


Widget _buildScreen({
  required int selectedIndex,
}) {
  switch (selectedIndex) {
    case 0:
      return const DashboardTabScreen();
    case 1:
      return const WarehouseTabScreen();
    case 2:
      return const RequestsTabScreen();
    case 3:
      return const SettingsTabScreen();
    default:
      return const Text("index default");
  }
}
