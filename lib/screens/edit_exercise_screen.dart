import 'dart:io';
import 'package:fitflow/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditExerciseScreen extends StatefulWidget {
  final CustomExercise? initialExercise;
  const EditExerciseScreen({super.key, this.initialExercise});

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  final WorkoutService _workoutService = WorkoutService();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late String _selectedMuscle;
  final List<String> _muscleGroups = ['Back', 'Chest', 'Legs', 'Shoulders', 'Biceps', 'Triceps', 'Abs'];

  String? _imagePath;
  String? _videoPath;

  bool get isEditMode => widget.initialExercise != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialExercise?.name ?? '');
    _descriptionController = TextEditingController(text: widget.initialExercise?.description ?? '');
    _selectedMuscle = widget.initialExercise?.muscleGroup ?? _muscleGroups.first;
    _imagePath = widget.initialExercise?.imagePath;
    _videoPath = widget.initialExercise?.videoPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(bool isVideo) async {
    final picker = ImagePicker();
    final XFile? file = isVideo
        ? await picker.pickVideo(source: ImageSource.gallery)
        : await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (file != null) {
      setState(() {
        if (isVideo) {
          _videoPath = file.path;
        } else {
          _imagePath = file.path;
        }
      });
    }
  }

  void _saveExercise() {
    if (_nameController.text.isEmpty) return;

    final newExerciseData = CustomExercise(
      name: _nameController.text,
      muscleGroup: _selectedMuscle,
      description: _descriptionController.text,
      imagePath: _imagePath,
      videoPath: _videoPath,
    );

    if (isEditMode) {
      _workoutService.updateCustomExercise(widget.initialExercise!, newExerciseData);
    } else {
      _workoutService.addCustomExercise(newExerciseData);
    }
    Navigator.of(context).pop();
  }
  
  void _deleteExercise() {
     showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF252836),
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "${widget.initialExercise!.name}"?'),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onPressed: () {
              _workoutService.deleteCustomExercise(widget.initialExercise!);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Exercise' : 'Add Exercise'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (isEditMode)
            IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
              onPressed: _deleteExercise,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(controller: _nameController, label: 'Exercise Name'),
            const SizedBox(height: 15),
            _buildTextField(controller: _descriptionController, label: 'Description (Optional)', maxLines: 3),
            const SizedBox(height: 15),
            _buildDropdown(),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _buildTextField(label: 'Sets', keyboardType: TextInputType.number)),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField(label: 'Reps', keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: _buildMediaButton(
                  icon: Icons.image_outlined, 
                  label: _imagePath == null ? 'Add Image' : 'Change Image',
                  onPressed: () => _pickMedia(false),
                )),
                const SizedBox(width: 15),
                Expanded(child: _buildMediaButton(
                  icon: Icons.videocam_outlined,
                  label: _videoPath == null ? 'Add Video' : 'Change Video',
                  onPressed: () => _pickMedia(true),
                )),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveExercise,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1F1D2B),
              ),
              child: const Text('Save Exercise', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({TextEditingController? controller, required String label, int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Theme.of(context).cardTheme.color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  
  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedMuscle,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedMuscle = newValue;
          });
        }
      },
      dropdownColor: const Color(0xFF252836),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
      decoration: InputDecoration(
        labelText: 'Target Muscle',
        filled: true,
        fillColor: Theme.of(context).cardTheme.color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      items: _muscleGroups.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildMediaButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white70),
      label: Text(label, style: const TextStyle(color: Colors.white70)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Theme.of(context).cardTheme.color!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
