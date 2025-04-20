import 'package:flutter/material.dart';
import 'package:rbac_manager/screens/users/users_screen.dart';
import 'package:rbac_manager/screens/roles/roles_screen.dart';
import 'package:rbac_manager/screens/applications/applications_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const UsersScreen(),
    const RolesScreen(),
    const ApplicationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          NavigationRail(
            leading: Text(
              "RBAC\nMANager",
              style: TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.white,
                    offset: Offset(1, 1),
                    blurRadius: 0.5,
                  ),
                ],
                fontSize: 32,
                decorationThickness: 2.0,
              ),
            ),
            extended: true,
            backgroundColor: Color(0xFF1C4E80),
            selectedIconTheme: IconThemeData(color: Colors.blueGrey),
            unselectedIconTheme: IconThemeData(color: Colors.white),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            selectedLabelTextStyle: TextStyle(
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.white,
                  offset: Offset(1, 1),
                  blurRadius: 0.5,
                ),
              ],
              fontSize: 18,
              decorationThickness: 2.0,
            ),
            unselectedLabelTextStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              decorationThickness: 2.0,
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.admin_panel_settings),
                label: Text('Roles'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.apps),
                label: Text('Applications'),
              ),
            ],
          ),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}
