import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './model/todo.dart';
import './constants/colors.dart';

class CreateItemPage extends StatefulWidget {
  @override
  _CreateItemPageState createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _todoTextController = TextEditingController();
  final _priorityController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _todoTextController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  void _addToDoItem() async {
    try {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a date')),
        );
        return;
      }

      ToDo newToDo = ToDo(
        id: '',
        todoText: _todoTextController.text,
        isDone: false,
        date: _selectedDate!,
        priority: int.parse(_priorityController.text),
      );
      await newToDo.saveToFirestore();
      Navigator.pop(context);
    } catch (error) {
      print('Error adding ToDo: $error');
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New To-Do'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _todoTextController,
              decoration: InputDecoration(
                labelText: 'To-Do Text',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.text_fields),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _priorityController,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.priority_high),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No Date Chosen!'
                        : 'Picked Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton.icon(
                  icon: Icon(Icons.date_range, color: tdBlue),
                  label: Text(
                    'Choose Date',
                    style: TextStyle(fontWeight: FontWeight.bold, color: tdBlue),
                  ),
                  onPressed: _presentDatePicker,
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add To-Do'),
                onPressed: _addToDoItem,
                style: ElevatedButton.styleFrom(
                  primary: tdBlue,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
