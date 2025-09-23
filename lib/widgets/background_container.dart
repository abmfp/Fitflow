import 'dart:io';
import 'package:fitflow/services/user_service.dart';
import 'package:fitflow/utils/app_theme.dart';
import 'package:flutter/material.dart';

class BackgroundContainer extends StatefulWidget {
  final Widget child;
  const BackgroundContainer({super.key, required this.child});

  @override
  State<BackgroundContainer> createState() => _BackgroundContainerState();
}

class _BackgroundContainerState extends State<BackgroundContainer> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _userService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _userService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _userService.backgroundImagePath;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.primaryBackgroundColor, // Default solid color
        image: imagePath != null && File(imagePath).existsSync()
            ? DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.cover,
                // Add a dark overlay to make text readable
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      child: widget.child,
    );
  }
}
