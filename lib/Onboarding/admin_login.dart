import 'package:flutter/material.dart';

class AdminLogin extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  AdminLogin({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center( // Center everything within this container
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Vertically center the form
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.1),
                    Image.asset(
                      "assets/images/splash.png",
                      height: 100,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.1),
                    Text(
                      "Admin Access Only!",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    // Form container
                    Container(
                      width: constraints.maxWidth > 600 ? 400 : double.infinity, // Center on large screens
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Phone number field
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Phone',
                                filled: true,
                                fillColor: Color(0xFFF5FCF9),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 16.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              onSaved: (phone) {
                                // Save it
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              // Password field
                              child: TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: 'Password',
                                  filled: true,
                                  fillColor: Color(0xFFF5FCF9),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 16.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                  ),
                                ),
                                onSaved: (password) {
                                  // Save it
                                },
                              ),
                            ),
                            // Sign in button
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  // Navigate to the main screen
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color.fromARGB(255, 230, 11, 11),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 48),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text("Sign in"),
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
