import 'package:flutter/material.dart';
import './model/todo.dart';
import './home.dart'; // Import the home page

class EditItemPage extends StatefulWidget {
  final ToDo? todo;

  const EditItemPage({Key? key, this.todo}) : super(key: key);

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController _textEditingController;
  late TextEditingController _dateEditingController;
  late TextEditingController _priorityEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: widget.todo?.todoText ?? '');
    _dateEditingController =
        TextEditingController(text: widget.todo?.date.toString() ?? '');
    _priorityEditingController = TextEditingController(
        text: widget.todo?.priority.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Task',
                prefixIcon: Icon(Icons.text_fields),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dateEditingController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _priorityEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Priority',
                prefixIcon: Icon(Icons.priority_high),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateEditingController.text = picked.toString();
      });
    }
  }

  void _updateTask() {
    if (widget.todo != null) {
      // Update the task and pop the page
      widget.todo!.todoText = _textEditingController.text;
      widget.todo!.date = DateTime.parse(_dateEditingController.text);
      widget.todo!.priority = int.parse(_priorityEditingController.text);
      widget.todo!.updateInFirestore();
    }
    Navigator.pop(context, true); // Pass true as a result to indicate successful update
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _dateEditingController.dispose();
    _priorityEditingController.dispose();
    super.dispose();
  }
}
