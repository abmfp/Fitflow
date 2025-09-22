import 'package:fitflow/utils/app_theme.dart';
import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  const GradientContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // Use the BoxDecoration with the gradient
      decoration: AppTheme.gradientBackground,
      child: child,
    );
  }
}
