import 'package:elearning/screens/score_screen.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> quizQuestions;
  final String courseId;
  final String taskId;

  const QuizScreen({
    required this.title,
    required this.quizQuestions,
    required this.courseId,
    required this.taskId,
    super.key,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int score = 0;

  late AnimationController _cardController;
  late Animation<Offset> _cardAnimation;

  @override
  void initState() {
    super.initState();

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _cardAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));

    _cardController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.quizQuestions[currentQuestionIndex];
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate a responsive width for the options (e.g., 80% of the screen width)
    double optionWidth = screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 6.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1} of ${widget.quizQuestions.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Question Card with Slide Animation
            SlideTransition(
              position: _cardAnimation,
              child: Card(
                elevation: 12.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                color: Colors.orange[100],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentQuestion['question'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 20),
                      // Options as clickable cards with consistent width
                      ...List.generate(currentQuestion['options'].length, (index) {
                        final option = currentQuestion['options'][index];
                        bool isSelected = currentQuestion['selectedAnswer'] == option;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentQuestion['selectedAnswer'] = option;
                            });
                          },
                          child: Container(
                            width: optionWidth, // Ensuring consistent width for options
                            margin: const EdgeInsets.only(bottom: 12.0),
                            child: Card(
                              color: isSelected ? Colors.deepOrangeAccent : Colors.white,
                              elevation: 6.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                  textAlign: TextAlign.center, // Center align text
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Next/Finish Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (currentQuestion['selectedAnswer'] == currentQuestion['correctAnswer']) {
                    score++;
                  }

                  if (currentQuestionIndex < widget.quizQuestions.length - 1) {
                    setState(() {
                      currentQuestionIndex++;
                      _cardController.forward(from: 0.0); // Trigger animation for the next question
                    });
                  } else {
                    // Calculate the percentage score
                    double percentageScore = (score / widget.quizQuestions.length) * 100;

                    // Quiz completed, pass the score as percentage to ScoreScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScoreScreen(
                          courseId: widget.courseId,
                          taskId: widget.taskId,
                          score: percentageScore.toStringAsFixed(2), // Pass score as a string with 2 decimal places
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10.0,
                ),
                child: Text(
                  currentQuestionIndex < widget.quizQuestions.length - 1 ? 'Next' : 'Finish',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
