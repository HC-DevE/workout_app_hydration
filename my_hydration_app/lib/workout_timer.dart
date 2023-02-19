// import 'package:flutter/material.dart';

// class WorkoutTimer extends StatefulWidget {
//   const WorkoutTimer({Key? key}) : super(key: key);

//   @override
//   _WorkoutTimerState createState() => _WorkoutTimerState();
// }

// class _WorkoutTimerState extends State<WorkoutTimer> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutTimer extends StatefulWidget {
  const WorkoutTimer({Key? key}) : super(key: key);

  @override
  _WorkoutTimerState createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
  static const int _workoutDuration = 30;

  Timer? _timer;
  int _remainingSeconds = _workoutDuration;

  Future<void> _saveWorkoutCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('workoutCompleted', true);
  }

  Future<bool> _getWorkoutCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('workoutCompleted') ?? false;
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds -= 1;

        if (_remainingSeconds == 0) {
          _stopTimer();
          _saveWorkoutCompletion();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _showExitConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Exiting the workout will mark it as incomplete.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _stopTimer();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_timer == null) {
          return true;
        } else {
          await _showExitConfirmationDialog();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workout Timer'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  '$_remainingSeconds',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_timer != null) {
                  _showExitConfirmationDialog();
                } else {
                  final workoutCompleted = await _getWorkoutCompletion();
                  if (!workoutCompleted) {
                    _startTimer();
                  }
                }
              },
              child: Text(
                _timer == null ? 'Start' : 'Exit',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

