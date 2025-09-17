// lib/widgets/gradient_background.dart
import 'package:fitflow/utils/app_theme.dart';
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: AppTheme.gradientBackground,
      child: child,
    );
  }
}
