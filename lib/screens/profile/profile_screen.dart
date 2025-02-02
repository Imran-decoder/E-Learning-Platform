import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
   

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? firstName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserFirstName();
  }

  Future<void> _fetchUserFirstName() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

<<<<<<< HEAD
        // Extract the first name from the document
        final String? fetchedFirstName =
            userDoc['Profile']['main']['firstName'];
        

        setState(() {
          firstName = fetchedFirstName ?? "User"; // Fallback to "User" if null
          isLoading = false; // Stop loading
          // img = fetchedImage;
          // img = fetchedImage != null ? Image.network(fetchedImage as String) : null;
=======
        final String? fetchedFirstName = userDoc['Profile']['main']['firstName'];

        setState(() {
          firstName = fetchedFirstName ?? "User";
          isLoading = false;
>>>>>>> 5547a72300003e1385816b1a70a94efb418e6b3d
        });
      } else {
        setState(() {
          firstName = "User";
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
      setState(() {
        firstName = "User";
        isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
<<<<<<< HEAD
      Navigator.pushReplacementNamed(
          context, '/log-sign'); // Navigate to login page
=======
      Navigator.pushReplacementNamed(context, '/log-sign');
>>>>>>> 5547a72300003e1385816b1a70a94efb418e6b3d
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: isLoading
            ? const CircularProgressIndicator()
            : Text(
<<<<<<< HEAD
                firstName ?? "User", // Show the first name in the AppBar title
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold, // Make the username bold
                ),
              ),
=======
          firstName ?? "User",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
>>>>>>> 5547a72300003e1385816b1a70a94efb418e6b3d
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 30),
            ProfileMenu(
              text: "My Account",
              icon: 'assets/icons/user.svg',
              press: () => {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/setting.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/help.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Admin Login",
              icon: "assets/icons/admin-eye.svg",
              press: () {
                Navigator.pushNamed(context, '/admin');
              },
            ),
            ProfileMenu(
              text: "Rate Us",
              icon: "assets/icons/rate-us.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/log-out.svg",
              press: () async {
                try {
                  await _signOut();
                  Navigator.pushReplacementNamed(context, '/log-sign');
                } on FirebaseAuthException catch (e) {
                  debugPrint(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

<<<<<<< HEAD
class ProfilePic extends StatefulWidget {
  const ProfilePic({
    super.key,
  });
=======
class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key});
>>>>>>> 5547a72300003e1385816b1a70a94efb418e6b3d

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  Image? img;
  @override
  void initState() {
    super.initState();
    _fetchUserProfilePicture();
  }

  Future<void> _fetchUserProfilePicture() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the user's document from Firestore
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users') // Ensure this matches your Firestore structure
            .doc(user.uid)
            .get();
        final Image? fetchedImage =
            userDoc['Profile']['main']['ProfilePicture'];
        setState(() {
          img = fetchedImage;
        });
      }
    } catch (e) {
      debugPrint('Error fetching user profile picture: $e');
      setState(() {
        img = null; // Handle errors gracefully
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
<<<<<<< HEAD
          CircleAvatar(
            backgroundImage: img != null
                ? NetworkImage((img as Image).image.toString())
                : AssetImage("assets/images/boy_illustration.png")
                    as ImageProvider, // Fallback to AssetImage
            radius: 50.0,
=======
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/boy_illustration.png"),
            radius: 60,
>>>>>>> 5547a72300003e1385816b1a70a94efb418e6b3d
          ),
          Positioned(
            right: -15,
            bottom: -10,
            child: SizedBox(
              height: 50,
              width: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: SvgPicture.string(cameraIcon),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    this.press,
  });

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFF7643),
<<<<<<< HEAD
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
=======
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
>>>>>>> 5547a72300003e1385816b1a70a94efb418e6b3d
          backgroundColor: const Color(0xFFF5F6F9),
          side: const BorderSide(color: Colors.grey),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(const Color(0xFFFF7643), BlendMode.srcIn),
              width: 24,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF757575),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

const cameraIcon =
    '''<svg width="20" height="16" viewBox="0 0 20 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M10 12.0152C8.49151 12.0152 7.26415 10.8137 7.26415 9.33902C7.26415 7.86342 8.49151 6.6619 10 6.6619C11.5085 6.6619 12.7358 7.86342 12.7358 9.33902C12.7358 10.8137 11.5085 12.0152 10 12.0152ZM10 5.55543C7.86698 5.55543 6.13208 7.25251 6.13208 9.33902C6.13208 11.4246 7.86698 13.1217 10 13.1217C12.133 13.1217 13.8679 11.4246 13.8679 9.33902C13.8679 7.25251 12.133 5.55543 10 5.55543ZM18.8679 13.3967C18.8679 14.2226 18.1811 14.8935 17.3368 14.8935H2.66321C1.81887 14.8935 1.13208 14.2226 1.13208 13.3967V5.42346C1.13208 4.59845 1.81887 3.92664 2.66321 3.92664H4.75C5.42453 3.92664 6.03396 3.50952 6.26604 2.88753L6.81321 1.41746C6.88113 1.23198 7.06415 1.10739 7.26604 1.10739H12.734C12.9358 1.10739 13.1189 1.23198 13.1877 1.41839L13.734 2.88845C13.966 3.50952 14.5755 3.92664 15.25 3.92664H17.3368C18.1811 3.92664 18.8679 4.59845 18.8679 5.42346V13.3967ZM17.3368 2.82016H15.25C15.0491 2.82016 14.867 2.69466 14.7972 2.50917L14.2519 1.04003C14.0217 0.418041 13.4113 0 12.734 0H7.26604C6.58868 0 5.9783 0.418041 5.74906 1.0391L5.20283 2.50825C5.13302 2.69466 4.95094 2.82016 4.75 2.82016H2.66321C1.19434 2.82016 0 3.98846 0 5.42346V13.3967C0 14.8326 1.19434 16 2.66321 16H17.3368C18.8057 16 20 14.8326 20 13.3967V5.42346C20 3.98846 18.8057 2.82016 17.3368 2.82016Z" fill="#757575"/>
</svg>
''';
