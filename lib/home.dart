import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './model/todo.dart';
import './constants/colors.dart';
import './widgets/todo_item.dart';
import './SignInPage.dart';
import './CreateItemPage.dart';
import './EditItemPage.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<ToDo> todosList;
  late List<ToDo> _foundToDo;
  bool isLoggedIn = false;
  String? username;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    todosList = [];
    _foundToDo = [];
    _fetchToDos();
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
      _firestore.collection('todos')
          .orderBy('priority', descending: true)
          .snapshots()
          .listen((snapshot) {
        setState(() {
          todosList.clear();
          todosList.addAll(snapshot.docs.map((doc) => ToDo.fromSnapshot(doc)));
          _foundToDo = List.from(todosList);
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
      body: Padding(
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
                children: _foundToDo
                    .map((todo) =>
                    ToDoItem(
                      todo: todo,
                      onToDoChanged: _handleToDoChange,
                      onDeleteItem: _deleteToDoItem,
                      onEditItem: _editToDoItem,
                    ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewToDo,
        icon: Icon(Icons.add),
        label: Text('Add ToDo'),
        backgroundColor: tdBlue,
      ),
    );
  }

  void _addNewToDo() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateItemPage()),
    );
    _fetchToDos();
  }

  void _handleToDoChange(ToDo todo) async {
    todo.isDone = !todo.isDone;
    await todo.updateInFirestore();
    _fetchToDos();
  }

  void _deleteToDoItem(String id) async {
    await ToDo(id: id,
        todoText: '',
        isDone: false,
        date: DateTime.now(),
        priority: 0).deleteFromFirestore();
    _fetchToDos();
  }

  void _editToDoItem(ToDo todo) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditItemPage(todo: todo)),
    );
    if (result == true) {
      _fetchToDos();
    }
  }


  void _runFilter(String enteredKeyword) {
    setState(() {
      _foundToDo = todosList
          .where((item) =>
          item.todoText.toLowerCase().contains(enteredKeyword.toLowerCase()))
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
