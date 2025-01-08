import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  // Screens for navigation
  final List<Widget> _screens = [
    AdminHomeScreen(),
    ManageCoursesScreen(),
    AdminProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          // Desktop layout with sidebar
          return Scaffold(
            backgroundColor: Colors.black,
            body: Row(
              children: [
                // Sidebar
                Container(
                  width: 250,
                  color: Colors.grey[850],
                  child: Sidebar(
                    selectedIndex: _selectedIndex,
                    onItemSelected: _onItemTapped,
                  ),
                ),
                Expanded(
                  child: _screens[_selectedIndex],
                ),
              ],
            ),
          );
        } else if (constraints.maxWidth >= 600) {
          // Tablet layout with AppBar and Drawer
          return Scaffold(
            appBar: AppBar(
              title: const Text('Admin Dashboard',
              style:TextStyle(color: Colors.white),
              ),

              backgroundColor: Colors.grey[850],
            ),
            drawer: Drawer(
              backgroundColor: Colors.grey[900],
              child: Sidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: _onItemTapped,
              ),
            ),
            body: _screens[_selectedIndex],
          );
        } else {
          // Mobile layout with floating BottomNavigationBar
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // Main content container
                Positioned.fill(
                  child: _screens[_selectedIndex],
                ),

                // Floating BottomNavigationBar
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BottomNavigationBar(
                        backgroundColor: Colors.transparent,
                        selectedItemColor: Colors.tealAccent,
                        unselectedItemColor: Colors.white54,
                        currentIndex: _selectedIndex,
                        onTap: _onItemTapped,
                        items: const [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.dashboard),
                            label: 'Dashboard',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.book),
                            label: 'Manage Courses',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.account_circle_outlined),
                            label: 'Profile',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DrawerHeader(
          child: Text(
            'Admin Panel',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildMenuItem(
          index: 0,
          icon: Icons.dashboard,
          label: 'Dashboard',
          context: context,
        ),
        _buildMenuItem(
          index: 1,
          icon: Icons.book,
          label: 'Manage Courses',
          context: context,
        ),
        _buildMenuItem(
          index: 2,
          icon: Icons.account_circle_outlined,
          label: 'People',
          context: context,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: selectedIndex == index ? Colors.tealAccent : Colors.white54,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: selectedIndex == index ? Colors.tealAccent : Colors.white54,
          fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer if open
        onItemSelected(index);
      },
      tileColor: selectedIndex == index ? Colors.grey[700] : Colors.transparent,
    );
  }
}

// Dummy Screens
class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Text(
          'Admin Home Screen',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class ManageCoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Text(
          'Manage Courses Screen',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class AdminProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Text(
          'Admin Profile Screen',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
