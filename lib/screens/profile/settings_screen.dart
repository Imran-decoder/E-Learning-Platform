import 'package:flutter/material.dart';
import 'package:elearning/Onboarding/terms_and_conditions.dart';
import 'package:elearning/screens/profile/edit_profile_screen.dart';
import 'package:elearning/screens/intro_screen.dart';





class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white, 
        centerTitle: true,// Set AppBar color to redAccent
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Account Settings
            const Text(
              'Account Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Profile'),
              subtitle: const Text('Edit your profile information'),
              leading: const Icon(Icons.person),
              onTap: () {
Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfileScreen()),
                        );              },
            ),
        
           
            const Divider(),

            // App Settings
            const Text(
              'App Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
           
            ListTile(
              title: const Text('Language'),
              subtitle: const Text('English'),
              leading: const Icon(Icons.language),
              onTap: () {
                // Navigate to Language Settings
              },
            ),
            ListTile(
              title: const Text('Terms and Conditions'),
              subtitle: const Text('Read our Terms and Conditions'),
              leading: const Icon(Icons.policy),
              onTap:(){
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
                        );
              },
            ),

           
                const Divider(),

              const Text(
              'About',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),


              ListTile(
              title: const Text('About'),
              subtitle: const Text('About This Application'),
              leading: const Icon(Icons.info),
              onTap:(){
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => IntroScreen()),
                        );
              },
            ),

            
          ],
        ),
      ),
    );
  }
}