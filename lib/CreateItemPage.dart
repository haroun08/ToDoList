import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './model/todo.dart';

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
        // Show an error if no date is selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a date')),
        );
        return;
      }

      ToDo newToDo = ToDo(
        id: '',
        todoText: _todoTextController.text,
        isDone: false,
        date: _selectedDate!, // Use the selected date
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
          children: [
            TextField(
              controller: _todoTextController,
              decoration: InputDecoration(
                labelText: 'To-Do Text',
              ),
            ),
            TextField(
              controller: _priorityController,
              decoration: InputDecoration(
                labelText: 'Priority',
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
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: Text(
                    'Choose Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addToDoItem,
              child: Text('Add To-Do'),
            ),
          ],
        ),
      ),
    );
  }
}
