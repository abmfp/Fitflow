import 'dart.io';
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
      decoration: imagePath != null && File(imagePath).existsSync()
        ? BoxDecoration( // Use this decoration if an image is selected
            image: DecorationImage(
              image: FileImage(File(imagePath)),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode( // Dark overlay for readability
                Colors.black.withOpacity(0.6),
                BlendMode.darken,
              ),
            ),
          )
        : AppTheme.defaultGradientBackground, // Use this if no image is selected
      child: widget.child,
    );
  }
}
