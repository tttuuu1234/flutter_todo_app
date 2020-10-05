import 'package:flutter/material.dart';

class TodoIncomplete extends StatelessWidget {
  TodoIncomplete(this.incompleteTodo);

  final List incompleteTodo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TodoIncomplete'),
      ),
      body: ListView.builder(
          itemCount: incompleteTodo.length,
          // ignore: missing_return
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(
                  incompleteTodo[index]['text'],
                  style: TextStyle(fontSize: 14),
                ),
                contentPadding: EdgeInsets.all(8),
              ),
            );
          }),
    );
  }
}
