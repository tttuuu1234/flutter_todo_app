import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../entity/todo_entity.dart';

class TodoDomain extends ChangeNotifier {
  String todo;
  List<TodoEntity> todos = [];
  List<TodoEntity> incompleteTodos = [];
  List<TodoEntity> completeTodos = [];

  // todosコレクション
  final todosCollection = FirebaseFirestore.instance.collection('todos');

  // todoの取得
  Future getTodos() async {
    final todos = await todosCollection.orderBy('createdAt').get();

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
    if (todo.isEmpty) {
      return;
    }
    await todosCollection.add(
      {
        'text': todo,
        'isCompleted': false,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now()
      },
    );

    todo = null;

    this.getTodos();
  }

  // textの更新
  Future updateTodoText({String id, String text}) async {
    if (todo.isEmpty) {
      return;
    }

    await todosCollection.doc(id).update(
      {
        'text': text,
        'updatedAt': DateTime.now(),
      },
    );

    todo = null;

    this.getTodos();
  }

  // todoの削除
  Future deleteTodo({String id}) async {
    await todosCollection.doc(id).delete();

    this.getTodos();
  }

  // todoを完了状態に更新
  Future completeTodo({String id}) async {
    await todosCollection.doc(id).update(
      {'isCompleted': true, 'updatedAt': DateTime.now()},
    );

    this.getTodos();
  }

  // 未完了のtodoの取得
  Future getIncompleteTodos() async {
    final incompleteTodos =
        await todosCollection.where('isCompleted', isEqualTo: false).get();

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
        await todosCollection.where('isCompleted', isEqualTo: true).get();

    final todoLists = completeTodos.docs
        .map(
          (todo) => TodoEntity(todo),
        )
        .toList();
    this.completeTodos = todoLists;
    notifyListeners();
  }

  // 完了済み火識別できる色の取得
  // ignore: missing_return
  Color getAmeberColor(bool isCompleted) {
    if (isCompleted) {
      return Colors.amber;
    }
  }

  // formatした登録日付とtodo内容を取得
  String getText({DateTime date, String text}) {
    return "${date.year}年 ${date.month}月${date.day}日 ${date.hour}時${date.minute}分\n$text";
  }
}
