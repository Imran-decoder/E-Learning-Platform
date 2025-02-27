import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<Map<String, String>> faqs = [
    {
      "question": "How do I reset my password?",
      "answer": "To reset your password, go to the login page and click on 'Forgot Password'."
    },
    {
      "question": "How can I contact support?",
      "answer": "You can contact support via the 'Contact Us' section in the app."
    },
    {
      "question": "Can I enroll in more than one course?",
      "answer": "Yes , you can enroll in more than one course"
    },
    {
      "question": "How do I enroll in a course?",
      "answer": "To enroll in a course, go to the course page and click on 'Enroll'."
    },
    {
      "question": "Do you have a desktop application",
      "answer": "Yes, we also have our desktop application available."
    },
    {
      "question": "Can I change my course after enrolling?",
      "answer": "Yes, you can change your course by going to the 'My Courses' section."
    },
    {
      "question": "How can I obtain more information about the courses?",
      "answer": "To obtain course details, one can refer the description section of their desired course"
    },
    {
      "question": "Is there a mobile app available?",
      "answer": "Yes, our mobile app is available for both iOS and Android."
    },
  ];

  List<Map<String, String>> filteredFaqs = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredFaqs = faqs; // Initialize filtered FAQs
  }

  void _filterFaqs(String query) {
    final filtered = faqs.where((faq) {
      return faq["question"]!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchQuery = query;
      filteredFaqs = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
        centerTitle:true , 
        foregroundColor: Colors.white,// Set AppBar color to redAccent
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image above the search bar
            Image.asset(
              'assets/images/faqs.jpg', // Replace with your image asset
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            // Search Bar
            TextField(
              onChanged: _filterFaqs,
              decoration: InputDecoration(
                hintText: 'Search FAQs...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.redAccent),
              ),
            ),
            const SizedBox(height: 16),
            // FAQ List
            Expanded(
              child: ListView.builder(
                itemCount: filteredFaqs.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(filteredFaqs[index]["question"]!),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(filteredFaqs[index]["answer"]!),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}