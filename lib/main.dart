import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:todo_app/ui/todo/list.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Firebaseを使用する前FlutterFileを初期化
  await Firebase.initializeApp();
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
