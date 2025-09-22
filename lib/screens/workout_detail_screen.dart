import 'dart:io';
import 'dart:ui'; // Import for ImageFilter
import 'package:fitflow/services/workout_service.dart';
import 'package:fitflow/widgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Exercise exercise;
  const WorkoutDetailScreen({super.key, required this.exercise});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.exercise.videoPath != null && File(widget.exercise.videoPath!).existsSync()) {
      _videoController = VideoPlayerController.file(File(widget.exercise.videoPath!))
        ..initialize().then((_) {
          if (mounted) {
            // Automatically loop the video for a better UX
            _videoController?.setLooping(true);
            setState(() {});
          }
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GradientContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMediaViewer(context),
              const SizedBox(height: 30),
              // Glassmorphism for Description
              _buildGlassmorphismContainer(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description', style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: 10),
                    Text(
                      widget.exercise.description ?? 'No description available for this exercise.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Glassmorphism for Sets/Reps
              _buildGlassmorphismContainer(
                context: context,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('3', style: Theme.of(context).textTheme.displayMedium),
                        const SizedBox(height: 4),
                        Text('Sets', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    Column(
                      children: [
                        Text('12', style: Theme.of(context).textTheme.displayMedium),
                        const SizedBox(height: 4),
                        Text('Reps', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaViewer(BuildContext context) {
    return AspectRatio(
      // --- CHANGE MADE HERE ---
      aspectRatio: 9 / 16, // Changed from 16 / 9 to 9 / 16 for portrait view
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              alignment: Alignment.center,
              child: _videoController?.value.isInitialized ?? false
                  ? InkWell(
                      onTap: () => setState(() => _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play()),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Ensure video fills the new aspect ratio
                          SizedBox.expand(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _videoController!.value.size.width,
                                height: _videoController!.value.size.height,
                                child: VideoPlayer(_videoController!),
                              ),
                            ),
                          ),
                          if (!_videoController!.value.isPlaying)
                            Icon(Icons.play_arrow_rounded, color: Colors.white.withOpacity(0.7), size: 80),
                        ],
                      ),
                    )
                  : widget.exercise.imagePath != null && File(widget.exercise.imagePath!).existsSync()
                      // The BoxFit.cover here is important to make the image fill the new taller container
                      ? Image.file(File(widget.exercise.imagePath!), fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                      : const Center(child: Icon(Icons.image_outlined, color: Colors.white54, size: 80)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphismContainer({required BuildContext context, required Widget child}) {
    return Container(
      // The margin was removed to allow the container to be flush with the content padding
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
