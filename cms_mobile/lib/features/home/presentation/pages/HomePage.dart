import 'package:cms_mobile/features/home/presentation/tabs/store_tab.dart';
import 'package:cms_mobile/features/home/presentation/tabs/material-transactions_tab.dart';
import 'package:cms_mobile/features/home/presentation/tabs/dashboard_tab.dart';
import 'package:cms_mobile/features/home/presentation/widgets/home_appbar.dart';
import 'package:cms_mobile/features/material_transactions/presentations/pages/proforma/create_proforma.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_bloc.dart';
import 'package:cms_mobile/features/projects/presentations/bloc/projects/project_event.dart';
import 'package:cms_mobile/features/progress/presentation/tabs/milestones_tab.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cms_mobile/features/theme/bloc/theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _onRefresh() async {}
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Create a key

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // init state to call get projects
  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(
          const GetProjects(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);

    return Scaffold(
      // drawer: BlurredDrawer(),
      appBar: CustomAppBar(_scaffoldKey),
      drawerDragStartBehavior: DragStartBehavior.start,
      key: _scaffoldKey,

      body: SafeArea(
        child: _buildScreen(selectedIndex: _selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
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
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'icons/navigations/milestone.svg',
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                  themeBloc.state.themeData.dividerColor, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              'icons/navigations/milestone.svg',
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                  themeBloc.state.themeData.primaryColor, BlendMode.srcIn),
            ),
            label: 'Milestones',
          ),
        ],
        currentIndex: _selectedIndex,
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
      return const StoreTabScreen();
    case 2:
      return const MaterialTransactionsTabScreen();
    case 3:
      return const CreateProformaPage();
    default:
      return const Text("index default");
  }
}
