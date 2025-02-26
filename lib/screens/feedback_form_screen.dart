import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackFormScreen extends StatefulWidget {
  final String courseId;
  final String userId;

  const FeedbackFormScreen({
    required this.courseId,
    required this.userId,
    super.key,
  });

  @override
  _FeedbackFormScreenState createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 0.0; // Default rating value
  final Map<String, String> _feedbackResponses = {
    "📚 How was the course content?": "",
    "⏳ Was the course duration appropriate?": "",
    "👍 Would you recommend this course?": "",
  };

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      FocusScope.of(context).unfocus(); // Dismiss keyboard

      Map<String, dynamic> feedbackData = {
        'timestamp': Timestamp.now(),
        'rating': _rating, // Add rating
        ..._feedbackResponses.map((key, value) => MapEntry(key, value.trim())),
      };

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('feedback')
          .doc(widget.courseId)
          .set(feedbackData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Feedback submitted successfully!'),
          backgroundColor: Colors.deepOrange,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please provide a rating before submitting!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Feedback Form'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                '💬 We value your feedback!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Feedback Questions with Emojis
              ..._feedbackResponses.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '✏️ Your response',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      validator: (value) => value!.trim().isEmpty ? '⚠️ Please enter a response' : null,
                      onChanged: (value) => _feedbackResponses[entry.key] = value,
                    ),
                  ],
                ),
              )),

              const SizedBox(height: 16),

              // Rating Bar ⭐⭐⭐⭐⭐
              const Text(
                '⭐ Rate the Course:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Center(
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    '🚀 Submit Feedback',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
