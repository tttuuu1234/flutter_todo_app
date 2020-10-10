import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/domain/todo_domain.dart';

class TodoIncomplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoDomain>(
      create: (_) => TodoDomain()..getIncompleteTodos(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('IncompleteTodo'),
        ),
        body: Consumer<TodoDomain>(
          builder: (context, model, child) {
            final incompleteTodos = model.incompleteTodos;
            final cards = incompleteTodos
                .map(
                  (incompleteTodo) => Card(
                    child: Container(
                      child: ListTile(
                        title: Text(
                          model.getText(
                            date: incompleteTodo.createdAt.toDate(),
                            text: incompleteTodo.text,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList();
            return ListView(
              children: cards,
            );
          },
        ),
      ),
    );
  }
}
