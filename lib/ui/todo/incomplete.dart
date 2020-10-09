import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/domain/firebase_todo_domain.dart';

class TodoIncomplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FirebaseTodoDomain>(
      create: (_) => FirebaseTodoDomain()..getIncompleteTodos(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('IncompleteTodo'),
        ),
        body: Consumer<FirebaseTodoDomain>(
          builder: (context, model, child) {
            final incompleteTodos = model.incompleteTodos;
            final cards = incompleteTodos
                .map(
                  (incompleteTodo) => Card(
                    child: Container(
                      child: ListTile(
                        title: Text(
                          model.getText(
                              date: incompleteTodo.updatedAt.toDate(),
                              text: incompleteTodo.text),
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
