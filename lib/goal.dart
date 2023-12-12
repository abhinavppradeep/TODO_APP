import 'dart:async';

import 'package:flutter/material.dart';

class GoalModeScreen extends StatefulWidget {
  const GoalModeScreen({Key? key}) : super(key: key);

  @override
  _GoalModeScreenState createState() => _GoalModeScreenState();
}

class _GoalModeScreenState extends State<GoalModeScreen> {
  TextEditingController _goalController = TextEditingController();
  int _selectedMinutes = 15;
  late Duration _countdownDuration;
  late Timer _timer;
  bool _timerActive = false;

  void _startCountdown() {
    _countdownDuration = Duration(minutes: _selectedMinutes);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownDuration.inSeconds > 0) {
          _countdownDuration -= Duration(seconds: 1);
        } else {
          _showTimeUpPopup();
          _timer.cancel();
          _timerActive = false;
        }
      });
    });
    _timerActive = true;
  }

  void _showTimeUpPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          title: Text("Time's Up!"),
          content: Text("Your goal time has elapsed."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('GOAL MODE'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your goal here:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _goalController,
              decoration: InputDecoration(
                hintText: 'e.g., Complete a chapter',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select time to finish:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                DropdownButton<int>(
                  value: _selectedMinutes,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedMinutes = value!;
                    });
                  },
                  items: [1, 5, 10, 15, 30, 45, 60]
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value minutes'),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  onPressed: () {
                    if (!_timerActive) {
                      _startCountdown();
                    }
                  },
                  child: Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _timerActive
                ? Text(
                    'Time Left: ${_countdownDuration.inMinutes}m:${(_countdownDuration.inSeconds % 60)}s',
                    style: TextStyle(fontSize: 18),
                  )
                : Container(),
          ],
        ),
      ),
      backgroundColor: Colors.lightGreen,
    );
  }
}
