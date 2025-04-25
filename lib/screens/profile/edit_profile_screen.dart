import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? userId;
  String? existingUsername; // To hold the existing address
  String? existingProfilePic; // To hold the existing profile picture URL

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser ;
      if (user != null) {
        userId = user.uid; // Get the user ID
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();

        // Populate the text controllers with user data
        setState(() {
          _firstNameController.text = userDoc['Profile']['main']['firstName'] ?? '';
          _lastNameController.text = userDoc['Profile']['main']['lastName'] ?? '';
          _phoneController.text = userDoc['Profile']['main']['phone'] ?? '';
          _addressController.text = userDoc['Profile']['main']['address'] ?? '';
          existingUsername = userDoc['userName'] ?? '';
          existingProfilePic = userDoc['Profile']['main']['profilePicture'] ?? ''; // Fetch existing profile picture
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> _updateProfile() async {
    // Validate input fields
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required. Please ensure that none are left empty.')),
      );
      return; // Exit the function if validation fails
    }

    try {
      // Update only the fields that have changed
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'Profile': {
          'main': {
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'phone': _phoneController.text,
            'address': _addressController.text, 
            'profilePicture': existingProfilePic, // Keep existing profile picture
          },
        },
        'userName': existingUsername,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your profile has been updated successfully.')),
      );

      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while updating your profile. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the screen size
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 16), // Space between fields
              const Text('First Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.person),
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16), // Space between fields
              const Text('Last Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16), // Space between fields
              const Text('Phone Number', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              const Text('Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_city),
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20), // Space before the button
              Center(
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text('Save Changes', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: 15), // Responsive padding
                    textStyle: const TextStyle(fontSize: 18),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}