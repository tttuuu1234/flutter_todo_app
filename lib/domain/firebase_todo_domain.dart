import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../entity/todo_entity.dart';

class FirebaseTodoDomain extends ChangeNotifier {
  String todo;
  List<TodoEntity> todos = [];
  List<TodoEntity> incompleteTodos = [];
  List<TodoEntity> completeTodos = [];

  final todoCollection = FirebaseFirestore.instance.collection('todos');

  // todoの取得
  Future getTodos() async {
    final todos = await todoCollection.orderBy('createdAt').get();

    final listTodos = todos.docs
        .map(
          (doc) => TodoEntity(doc),
        )
        .toList();

    this.todos = listTodos;
    notifyListeners();
  }

  // todoの追加
  Future addTodo() async {
    await todoCollection.add(
      {'text': todo, 'isCompleted': false, 'createdAt': DateTime.now()},
    );
    print('追加成功 ' + todo);

    this.getTodos();
  }

  // textの更新
  Future updateTodoText({String id, String text}) async {
    await todoCollection.doc(id).update(
      {'text': text},
    );

    this.getTodos();
  }

  // todoの削除
  Future deleteTodo({String id}) async {
    await todoCollection.doc(id).delete();

    this.getTodos();
  }

  // todoを完了状態に更新
  Future completeTodo({String id}) async {
    await todoCollection.doc(id).update(
      {'isCompleted': true},
    );

    this.getTodos();
  }

  // 未完了のtodoの取得
  Future getIncompleteTodos() async {
    final incompleteTodos =
        await todoCollection.where('isCompleted', isEqualTo: false).get();

    final todoLists = incompleteTodos.docs
        .map(
          (todo) => TodoEntity(todo),
        )
        .toList();
    this.incompleteTodos = todoLists;
    notifyListeners();
  }

  // 完了済みのtodoの取得
  Future getCompleteTodos() async {
    final completeTodos =
        await todoCollection.where('isCompleted', isEqualTo: true).get();

    final todoLists = completeTodos.docs
        .map(
          (todo) => TodoEntity(todo),
        )
        .toList();
    this.completeTodos = todoLists;
    notifyListeners();
  }
}
