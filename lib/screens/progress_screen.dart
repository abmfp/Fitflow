  // ... inside _ProgressScreenState class ...

  Widget _buildTodayStatsCard(BuildContext context) {
    // Check if a workout for today has been completed and saved
    final completedWorkout = _workoutService.todaysCompletedWorkout;
    bool workoutIsFinished = completedWorkout.isNotEmpty;
    
    // Determine which numbers to show
    final int exercisesDone = workoutIsFinished ? completedWorkout.length : _workoutService.completedExercisesCount;
    final int totalExercises = workoutIsFinished ? completedWorkout.length : _workoutService.totalExercisesCount;
    final double completion = totalExercises == 0 ? 0 : (exercisesDone / totalExercises) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              '$exercisesDone / $totalExercises',
              'Exercises Done',
            ),
            _buildStatItem(
              context,
              '${completion.toStringAsFixed(0)}%',
              'Completion',
            ),
          ],
        ),
      ),
    );
  }

  // ... rest of the ProgressScreen file is the same ...
