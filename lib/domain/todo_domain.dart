import 'package:flutter/material.dart';

class TodoDomain extends ChangeNotifier {
  String todo;
  List todos = [
    {
      'isCompleted': false,
      'text': '今日はFlutterのお勉強をします。目標はTodoアプリの完成です。頑張ります。応援して下さい。'
    }
  ];

  void addTodo() {
    if (todo.isEmpty) {
      return;
    }

    // todosに連想配列を追加するため
    Map todoData = {
      'isCompleted': false,
      'text': todo
    };

    // todosの配列にt連想配列のtodoDataを追加
    todos.add(todoData);
    // 状態をなくしている 無くさないと追加ボタンとか押した時にtodoに前に入力したデータが残ってちゃう
    todo = null;

    // notifyListeners()でTodoDomainが使用されているChangeNotifyProviderに変更を通知
    notifyListeners();
  }

  void editTodo(int index) {
    // 編集されたtodosの中のtodoのindexを引数でもらって、todosの中のindex番号のtodoを編集したtodoに書き換えている
    todos[index]['text'] = todo;
    todo = null;

    notifyListeners();
  }

  void deleteTodo(int index) {
    todos.removeAt(index);

    notifyListeners();
  }
}
