import 'package:flutter/material.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Plan Screen', style: Theme.of(context).textTheme.displayLarge),
      ),
    );
  }
}
