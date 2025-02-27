import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  String? firstName;
  String? lastName;
  String? email;
  String? userId;
  String? phone;
  String? address;
  String? profilePictureUrl;
  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser ;
      if (user != null) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        setState(() {
          firstName = userDoc['Profile']['main']['firstName'] ?? "User   ";
          lastName = userDoc['Profile']['main']['lastName'] ?? "User   ";
          email = user.email;
          phone = userDoc['Profile']['main']['phone'] ?? "Not available";
          address = userDoc['Profile']['main']['address'] ?? "Not available";
          profilePictureUrl = userDoc['Profile']['main']['profilePicture'] ?? null;
          userName = userDoc['userName'] ?? "User   ";
        });
      } else {
        setState(() {
          firstName = null;
          lastName = null;
          email = null;
          phone = null;
          address = null;
          userName = null;
        });
      }
    } catch (e) {
      debugPrint('Error fetching user details: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final double screenWidth = MediaQuery.of(context).size.width;

    // Set a responsive size for the profile picture
    double profilePictureSize = screenWidth < 600 ? screenWidth * 0.25 : screenWidth * 0.15; // 25% for mobile, 15% for web

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile Picture
                      Container(
                        width: profilePictureSize, // Responsive width
                        height: profilePictureSize, // Responsive height
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: profilePictureUrl != null
                                ? NetworkImage(profilePictureUrl!)
                                : const AssetImage("assets/images/boy_illustration.png") as ImageProvider,
                            fit: BoxFit.cover, // Ensure the image covers the circle
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // User Details Card
                      Card(
                        elevation: 4,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildUserInfoRow(Icons.person, 'User Name:', userName ?? 'User   '),
                              _buildUserInfoRow(Icons.person, 'First Name:', firstName ?? 'Not available'),
                              _buildUserInfoRow(Icons.person, 'Last Name:', lastName ?? 'Not available'),
                              _buildUserInfoRow(Icons.email, 'Email:', email ?? 'Not available'),
                              _buildUserInfoRow(Icons.phone, 'Phone Number:', phone ?? 'Not available'),
                              _buildUserInfoRow(Icons.home, 'Address:', address ?? 'Not available'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildUserInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.redAccent, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(value, style: const TextStyle(fontSize: 18)), // Slightly smaller font size
              ],
            ),
          ),
        ],
      ),
    );
  }
}