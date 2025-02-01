import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elearning/db_operations/users.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInUserWithEmailAndPassword() async {
    try {
      final UserCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      String userID = FirebaseAuth.instance.currentUser!.uid;
      if (FirebaseAuth.instance.currentUser != null) {
        if (await checkUserProfile(userID) == true) {
          Navigator.pushNamed(context, '/dashboard');
        } else {
          Navigator.pushNamed(context, '/secpage');
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<bool> checkUserProfile(String userID) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('Users').doc(userID).get();
      return doc.exists; // True if profile exists, false otherwise
    } catch (e) {
      throw 'Failed to check user profile: $e';
    }
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
     ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text('Password reset link sent to your email'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double buttonWidth = constraints.maxWidth > 600 
            ? 500 // Fixed for desktop 
            : constraints.maxWidth* 0.9;//Mobile: 90% of screen width 
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.asset('assets/images/splash.png', height: 146),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Text(
                    "Sign In",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: buttonWidth,
                          child:TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Mail or Phone',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 24),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          // keyboardType: TextInputType.phone,
                          onSaved: (phone) {
                            // Save it
                          },
                        ),
                      ),
                          
                          
                          
                        
                        SizedBox(
                          width:buttonWidth,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              fillColor: Color(0xFFF5FCF9),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 24),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            onSaved: (passaword) {
                              // Save it
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Center( 
                          child:SizedBox(
                          width:buttonWidth,
                          child: ElevatedButton(
                        
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              try {
                                if (emailController.text.trim().isEmpty ||
                                    passwordController.text.trim().isEmpty) {
                                  throw 'Please enter email and password';
                                } else {
                                  await signInUserWithEmailAndPassword();
                                }
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF00BF6D),
                            foregroundColor: Colors.white,
                            minimumSize: Size(buttonWidth, 70),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Sign in"),
                          ),
                        ),
                      ), 
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () async {
                            if (emailController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please enter your email'),
                                backgroundColor: Colors.red,
                              ));
                            } else {
                              await resetPassword();
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical:16, horizontal: 24),
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(0.64),
                                ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text.rich(
                            const TextSpan(
                              text: "Don’t have an account? ",
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(color: Color(0xFF00BF6D)),
                                ),
                              ],
                            ),
                            
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(0.64),
                                ),
                          ),
                        ),
                         TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/admin');
                          },
                          child: Text.rich(
                            const TextSpan(
                              text: "ADMIN LOGIN! ",
                              children: [
                                TextSpan(
                                  text: "Click Here",
                                  style: TextStyle(color: Color(0xFF00BF6D)),
                                ),
                              ],
                            ),
                            
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(0.64),
                                ),
                          ),
                        ),
                      ],
                      
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
