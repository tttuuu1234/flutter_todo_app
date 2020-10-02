import 'package:flutter/material.dart';

class TodoDomain extends ChangeNotifier {
  String todo;
  List todos = ['aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'];

  void addTodo() {
    if (todo.isEmpty) {
      return;
    }

    // todosの配列にtodoを追加
    todos.add(todo);
    todo = null;

    // notifyListeners()でTodoDomainが使用されているChangeNotifyProviderに変更を通知
    notifyListeners();
  }
}
