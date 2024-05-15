import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    this.id,
    this.todoText,
    this.isDone = false,
  });

  // Method to convert Firestore document snapshot to ToDo object
  factory ToDo.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    return ToDo(
      id: snapshot.id,
      todoText: data['todoText'],
      isDone: data['isDone'] ?? false,
    );
  }

  // Method to fetch ToDo items from Firestore
  static Future<List<ToDo>> fetchToDos() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('todos').get();
      return snapshot.docs.map((doc) => ToDo.fromSnapshot(doc)).toList();
    } catch (error) {
      print('Error fetching ToDos from Firestore: $error');
      return [];
    }
  }

  // Save ToDo item to Firestore
  Future<void> saveToFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('todos')
          .doc(id)
          .set({
        'todoText': todoText,
        'isDone': isDone,
      });
    } catch (error) {
      print('Error saving ToDo item to Firestore: $error');
    }
  }
}
