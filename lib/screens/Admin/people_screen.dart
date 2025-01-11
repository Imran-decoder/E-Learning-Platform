import 'package:flutter/material.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(  // SafeArea added to prevent UI overlap with status bar
        top: true,  // Ensure SafeArea takes account of the status bar area
        child: Padding(
          padding: const EdgeInsets.only(top: 42.0, left: 18.0, right: 18.0),  // Increased top padding for more space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Admin",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildPersonTile("Admin", isAdmin: true),
              const SizedBox(height: 16),
              const Text(
                "Classmates",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: 70, // Number of classmates
                  itemBuilder: (context, index) {
                    final classmates = [
                      "CHAUDHARY MOHD ARSHAD",
                      "SHAYAN AHMED",
                      "ANSARI IMRAN",
                      "TAUQEER AHMED",
                    ];

                    return _buildPersonTile(
                      classmates[index % classmates.length],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonTile(String name, {bool isAdmin = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isAdmin ? Colors.tealAccent : Colors.grey[800],
        child: Icon(
          isAdmin ? Icons.person : Icons.person_outline,
          color: Colors.black,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
