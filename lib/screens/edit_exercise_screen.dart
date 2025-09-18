// We need the CustomExercise model
import 'package:flutter/material.dart';

class EditExerciseScreen extends StatefulWidget {
  // If an exercise is passed, we're in "Edit" mode. If it's null, we're in "Add" mode.
  final CustomExercise? initialExercise;

  const EditExerciseScreen({super.key, this.initialExercise});

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late String _selectedMuscle;
  final List<String> _muscleGroups = ['Back', 'Chest', 'Legs', 'Shoulders', 'Biceps', 'Triceps', 'Abs'];

  bool get _isEditMode => widget.initialExercise != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialExercise?.name ?? '');
    _descriptionController = TextEditingController(); // Description is optional
    _selectedMuscle = widget.initialExercise?.muscleGroup ?? _muscleGroups.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveExercise() {
    // In a real app, you would save this data to a database.
    // For now, we'll just pop the screen.
    // In the next step, we'll pass the data back to the library screen.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Exercise' : 'Add Exercise'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Only show the delete icon in Edit mode
          if (_isEditMode)
            IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
              onPressed: () {
                // TODO: Implement delete confirmation and logic
                Navigator.of(context).pop();
              },
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
            // A Row for Sets and Reps
            Row(
              children: [
                Expanded(child: _buildTextField(label: 'Sets', keyboardType: TextInputType.number)),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField(label: 'Reps', keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 30),
            // A Row for Image and Video buttons
            Row(
              children: [
                Expanded(child: _buildMediaButton(icon: Icons.image_outlined, label: 'Add Image')),
                const SizedBox(width: 15),
                Expanded(child: _buildMediaButton(icon: Icons.videocam_outlined, label: 'Add Video')),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveExercise,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: const Text('Save Exercise', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable widget for text fields to keep the code clean
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
  
  // Widget for the muscle group dropdown
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
      items: _muscleGroups.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Target Muscle',
        filled: true,
        fillColor: Theme.of(context).cardTheme.color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Reusable widget for the media buttons
  Widget _buildMediaButton({required IconData icon, required String label}) {
    return OutlinedButton.icon(
      onPressed: () {},
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
