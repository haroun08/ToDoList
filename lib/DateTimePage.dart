import 'package:flutter/material.dart';
import 'dart:async';
import './constants/colors.dart';

class DateTimePage extends StatefulWidget {
  @override
  _DateTimePageState createState() => _DateTimePageState();
}

class _DateTimePageState extends State<DateTimePage> {
  late Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream = _createTimeStream();
  }

  Stream<DateTime> _createTimeStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield DateTime.now().add(Duration(hours: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date and Time'),
        backgroundColor: tdBlue,
      ),
      body: Center(
        child: StreamBuilder<DateTime>(
          stream: _timeStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            DateTime now = snapshot.data ?? DateTime.now();

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 50, color: tdBlue),
                SizedBox(height: 20),
                Text(
                  'Date: ${now.year}-${_formatNumber(now.month)}-${_formatNumber(now.day)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Icon(Icons.access_time, size: 50, color: tdBlue),
                SizedBox(height: 20),
                Text(
                  'Time: ${_formatNumber(now.hour)}:${_formatNumber(now.minute)}:${_formatNumber(now.second)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number < 10 ? '0$number' : '$number';
  }
}
