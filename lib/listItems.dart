import 'package:flutter/material.dart';

class ListItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Date and Time'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Date: ${now.year}-${_formatNumber(now.month)}-${_formatNumber(now.day)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Time: ${_formatNumber(now.hour)}:${_formatNumber(now.minute)}:${_formatNumber(now.second)}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number < 10 ? '0$number' : '$number';
  }
}
