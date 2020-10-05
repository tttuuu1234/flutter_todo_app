import 'package:flutter/material.dart';

class TodoComplete extends StatelessWidget {
  TodoComplete(this.completeTodo);

  final List completeTodo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TodoComplete'),
      ),
      body: ListView.builder(
        itemCount: completeTodo.length,
        // ignore: missing_return
        itemBuilder: (context, index) {
          if (completeTodo[index]['isCompleted']) {
            return Card(
              child: ListTile(
                title: Text(
                  completeTodo[index]['text'],
                  style: TextStyle(fontSize: 14),
                ),
                contentPadding: EdgeInsets.all(8),
              ),
            );
          }
        },
      ),
    );
  }
}
