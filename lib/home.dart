import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './model/todo.dart';
import './constants/colors.dart';
import './widgets/todo_item.dart';
import './SignInPage.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final todosList = <ToDo>[]; // Updated to an empty list
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  bool isLoggedIn = false; // Flag to track if user is logged in
  String? username; // Variable to store username

  @override
  void initState() {
    _getUserInfo();
    _fetchToDos(); // Fetch todos from Firestore
    super.initState();
  }

  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        isLoggedIn = true;
        username = user.displayName;
      });
    }
  }

  Future<void> _fetchToDos() async {
    try {
      _firestore.collection('todos').snapshots().listen((snapshot) {
        setState(() {
          todosList.clear(); // Clear existing todos
          todosList.addAll(snapshot.docs.map((doc) {
            return ToDo(
              id: doc.id,
              todoText: doc['todoText'],
              isDone: doc['isDone'] ?? false, // Ensure isDone is always present
            );
          }));
          _foundToDo = List.from(todosList); // Update _foundToDo as well
        });
      });
    } catch (error) {
      print('Error fetching ToDos: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'All ToDos',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: tdBlack,
                  ),
                ),
                SizedBox(height: 20),
                searchBox(),
                SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: _foundToDo.reversed
                        .map((todo) => ToDoItem(
                      todo: todo,
                      onToDoChanged: _handleToDoChange,
                      onDeleteItem: _deleteToDoItem,
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'Add a new todo item',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: tdBlue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, size: 30, color: Colors.white),
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) async {
    setState(() {
      todo.isDone = !todo.isDone;
    });

    // Update the todo in Firestore
    try {
      await _firestore.collection('todos').doc(todo.id).update({
        'isDone': todo.isDone,
      });
    } catch (error) {
      print('Error updating ToDo: $error');
    }
  }

  void _deleteToDoItem(String id) async {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });

    // Delete the todo from Firestore
    try {
      await _firestore.collection('todos').doc(id).delete();
    } catch (error) {
      print('Error deleting ToDo: $error');
    }
  }

  void _addToDoItem(String toDo) async {
    try {
      // Add the todo to Firestore
      await _firestore.collection('todos').add({
        'todoText': toDo,
        'isDone': false,
      });
    } catch (error) {
      print('Error adding ToDo: $error');
    }
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _foundToDo = todosList
          .where((item) =>
          item.todoText!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        onChanged: _runFilter,
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/DateTimePage');
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.menu, color: tdBlack),
        ),
      ),
      actions: [
        isLoggedIn
            ? Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/avatar.jpeg'),
              ),
              SizedBox(width: 10),
              Text(
                username ?? '',
                style: TextStyle(color: tdBlack),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  setState(() {
                    isLoggedIn = false;
                    username = null;
                  });
                },
                child: Text('Logout'),
              ),
            ],
          ),
        )
            : Padding(
          padding: EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/SignInPage');
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/avatar.jpeg'),
            ),
          ),
        ),
      ],
    );
  }
}
