import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TodoLists'),
      ),
      body: Container(
        child: Text('テスト'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 80,
              child: DrawerHeader(
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 36, color: Colors.white),
                ),
                decoration: BoxDecoration(color: Colors.blue),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('TodoLists'),
                onTap: () {
                  print('TodoListsページに遷移');
                  // todo TodoListsページに遷移させる
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Incomplete'),
                onTap: () {
                  print('未完了ページに遷移');
                  // todo Incompleteページに遷移させる
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Complete'),
                onTap: () {
                  print('完了ページに遷移');
                  // todo Completeページに遷移させる
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
