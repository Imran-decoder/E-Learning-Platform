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
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Lottie.asset(
        animationPath,
        fit: BoxFit.cover,
        repeat: true,
      ),
    );
  }
}
