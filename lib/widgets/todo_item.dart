import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../EditItemPage.dart'; // Import EditItemPage.dart

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) onToDoChanged;
  final Function(String) onDeleteItem;
  final Function(ToDo) onEditItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
    required this.onEditItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todo.todoText,
            style: TextStyle(
              decoration: todo.isDone ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          Text('Date: ${_formatDate(todo.date)}'),
          Text('Priority: ${todo.priority}'),
          // Add more fields as needed
        ],
      ),
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (value) {
          onToDoChanged(todo);
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editTask(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              onDeleteItem(todo.id);
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _editTask(BuildContext context) async {
    // Navigate to the edit page
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemPage(todo: todo),
      ),
    );
    // Call the callback to update the UI
    onEditItem(todo);
  }
}
