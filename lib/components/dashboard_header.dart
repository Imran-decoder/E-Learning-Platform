import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DashboardHeader extends StatelessWidget {
  final String animationPath;

  const DashboardHeader({
    super.key,
    required this.animationPath,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double animationSize = constraints.maxWidth * 1; // Adjustable size based on width

        return Container(
          width: double.infinity, // Full width
          height: constraints.maxHeight * 1, // Scales based on available height
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Lottie.asset(
              animationPath,
              width: animationSize, // Dynamic width
              height: animationSize, // Dynamic height
              fit: BoxFit.contain, // Ensures proper scaling
              repeat: true,
            ),
          ),
        );
      },
    );
  }
}
