import 'package:flutter/material.dart';

class TodoDomain extends ChangeNotifier {
  String todo;
  List todos = ['今日はFlutterのお勉強をします。目標はTodoアプリの完成です。頑張ります。応援して下さい。'];

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
