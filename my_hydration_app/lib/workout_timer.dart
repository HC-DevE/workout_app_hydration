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

class WorkoutTimer extends StatefulWidget {
  const WorkoutTimer({Key? key}) : super(key: key);

  @override
  _WorkoutTimerState createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
  bool _isRunning = false;
  int _remainingTime = 0;
  late Timer _timer;

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
        if (_remainingTime <= 0) {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _isRunning = false;
    _timer.cancel();
  }

  void _setTimer(int minutes) {
    setState(() {
      _remainingTime = minutes * 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${_remainingTime ~/ 60}:${_remainingTime % 60}',
          style: TextStyle(fontSize: 48),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isRunning ? null : () => _setTimer(5),
              child: Text('5 min'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: _isRunning ? null : () => _setTimer(10),
              child: Text('10 min'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: _isRunning ? null : () => _setTimer(15),
              child: Text('15 min'),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isRunning ? _stopTimer : null,
              child: Text('Stop'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: _isRunning ? null : _startTimer,
              child: Text('Start'),
            ),
          ],
        ),
      ],
    );
  }
}

