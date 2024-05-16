import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  String id;
  String todoText;
  bool isDone;
  DateTime date;
  int priority;

  ToDo({
    required this.id,
    required this.todoText,
    required this.isDone,
    required this.date,
    required this.priority,
  });

  factory ToDo.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    return ToDo(
      id: snapshot.id,
      todoText: data['todoText'],
      isDone: data['isDone'] ?? false,
      date: (data['date'] as Timestamp).toDate(),
      priority: data['priority'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'todoText': todoText,
      'isDone': isDone,
      'date': date,
      'priority': priority,
    };
  }

  Future<void> saveToFirestore() async {
    try {
      if (id.isEmpty) {
        DocumentReference docRef = await FirebaseFirestore.instance.collection('todos').add(toMap());
        id = docRef.id;
      } else {
        await FirebaseFirestore.instance.collection('todos').doc(id).set(toMap());
      }
    } catch (error) {
      print('Error saving ToDo item to Firestore: $error');
    }
  }

  Future<void> updateInFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('todos').doc(id).update(toMap());
    } catch (error) {
      print('Error updating ToDo item in Firestore: $error');
    }
  }

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

  Future<void> deleteFromFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('todos').doc(id).delete();
    } catch (error) {
      print('Error deleting ToDo item from Firestore: $error');
    }
  }
}
