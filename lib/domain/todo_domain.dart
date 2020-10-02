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
    // 状態をなくしている 無くさないと追加ボタンとか押した時にtodoに前に入力したデータが残ってちゃう
    todo = null;

    // notifyListeners()でTodoDomainが使用されているChangeNotifyProviderに変更を通知
    notifyListeners();
  }

  void editTodo(int index) {
    // 編集されたtodosの中のtodoのindexを引数でもらって、todosの中のindex番号のtodoを編集したtodoに書き換えている
    todos[index] = todo;
    todo = null;

    notifyListeners();
  }
}
