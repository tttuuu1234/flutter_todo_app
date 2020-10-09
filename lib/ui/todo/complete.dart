import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/domain/firebase_todo_domain.dart';

class TodoComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FirebaseTodoDomain>(
      create: (_) => FirebaseTodoDomain()..getCompleteTodos(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('completeTodo'),
        ),
        body: Consumer<FirebaseTodoDomain>(
          builder: (context, model, child) {
            final completeTodos = model.completeTodos;
            final cards = completeTodos
                .map(
                  (completeTodo) => Card(
                    child: Container(
                      child: ListTile(
                        title: Text(
                          model.getText(
                            date: completeTodo.updatedAt.toDate(),
                            text: completeTodo.text,
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
