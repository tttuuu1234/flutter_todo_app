import 'package:flutter/material.dart';

import 'ui/todo/list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todoアプリ',
      home: TodoList(),
    );
  }
}
