import 'package:cloud_firestore/cloud_firestore.dart';

class TodoEntity {
  TodoEntity(DocumentSnapshot doc) {
    id = doc.id;
    text = doc.data()['text'];
    isCompleted = doc.data()['isCompleted'];
    createdAt = doc.data()['createdAt'];
    updatedAt = doc.data()['updatedAt'];
  }

  String id;
  String text;
  bool isCompleted;
  Timestamp createdAt;
  Timestamp updatedAt;
}
