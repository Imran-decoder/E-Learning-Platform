import 'package:flutter/material.dart';
import 'people_screen.dart';
import 'manage_course_screen.dart';
import 'admin_dashboard.dart';
import 'feedback_responses_screen.dart'; // Import feedback screen

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  // Screens for navigation
  final List<Widget> _screens = [
    AdminHomeScreen(),
    ManageCourseScreen(),
    PeopleScreen(),
    FeedbackResponsesScreen(), // Added feedback response screen
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
                  color: Colors.black, // Fully dark sidebar
                  child: Sidebar(
                    selectedIndex: _selectedIndex,
                    onItemSelected: _onItemTapped,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black, // Ensuring dark background
                    child: _screens[_selectedIndex],
                  ),
                ),
              ],
            ),
          );
        } else if (constraints.maxWidth >= 600) {
          // Tablet layout with AppBar and Drawer
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Admin Dashboard',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black, // Dark theme for app bar
            ),
            drawer: Drawer(
              backgroundColor: Colors.black,
              child: Sidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: _onItemTapped,
              ),
            ),
            body: Container(
              color: Colors.black,
              child: _screens[_selectedIndex],
            ),
          );
        } else {
          // Mobile layout with floating BottomNavigationBar
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.black,
                    child: _screens[_selectedIndex],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black, // Fully dark navbar
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
                        backgroundColor: Colors.black,
                        selectedItemColor: Colors.tealAccent,
                        unselectedItemColor: Colors.white70,
                        type: BottomNavigationBarType.fixed,
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
                            icon: Icon(Icons.people),
                            label: 'People',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.feedback),
                            label: 'Feedback',
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
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Fully dark theme
      child: Column(
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
          ),
          _buildMenuItem(
            index: 1,
            icon: Icons.book,
            label: 'Manage Courses',
          ),
          _buildMenuItem(
            index: 2,
            icon: Icons.people,
            label: 'People',
          ),
          _buildMenuItem(
            index: 3,
            icon: Icons.feedback,
            label: 'Feedback',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: selectedIndex == index ? Colors.tealAccent : Colors.white70,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: selectedIndex == index ? Colors.tealAccent : Colors.white70,
          fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        onItemSelected(index);
      },
      tileColor: selectedIndex == index ? Colors.grey[800] : Colors.transparent,
    );
  }
}
