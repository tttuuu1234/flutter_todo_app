import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/domain/firebase_todo_domain.dart';

import 'complete.dart';
import 'incomplete.dart';

class TodoList extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FirebaseTodoDomain>(
      create: (_) => FirebaseTodoDomain()..getTodos(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('TodoLists'),
          actions: <Widget>[
            Consumer<FirebaseTodoDomain>(
              builder: (context, model, child) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            '追加したいTodoを教えて！',
                            style: TextStyle(fontSize: 14),
                          ),
                          content: Form(
                            key: _formKey,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '今日する事教えてくれないの。。？';
                                }
                              },
                              onChanged: (String text) async {
                                model.todo = text;
                              },
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                }
                                try {
                                  // todoの追加
                                  await model.addTodo();
                                  Navigator.pop(context);
                                } catch (e) {
                                  print('今日する事が入力されていません');
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            )
          ],
        ),
        body: Consumer<FirebaseTodoDomain>(
          builder: (context, model, child) {
            final todos = model.todos;
            final cards = todos
                .map(
                  (todo) => Card(
                    child: Container(
                      color: model.getAmeberColor(todo.isCompleted),
                      child: ListTile(
                        title: Text(
                          model.getFormatedDate(todo.createdAt.toDate()),
                          style: TextStyle(fontSize: 14),
                        ),

                        subtitle: Text(todo.text),
                        contentPadding: EdgeInsets.all(8),
                        onLongPress: () {
                          if (!todo.isCompleted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '完了しましたか？',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  // AlertDialogではボタン関係はactionsで定義しなくてはいけない
                                  actions: [
                                    FlatButton(
                                      onPressed: () async {
                                        await model.completeTodo(id: todo.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('NG'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        // ListTileのtrailingに2つアイコンを並べたい時はWrapしてあげる
                        trailing: Wrap(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        '追加したTodo間違えちゃった？',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      content: Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          initialValue: todo.text,
                                          // ignore: missing_return
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              print(value);
                                              return '今日する事教えてくれないの。。？';
                                            }
                                          },
                                          onChanged: (String text) {
                                            print(text);
                                            model.todo = text;
                                          },
                                        ),
                                      ),
                                      // AlertDialogではボタン関係はactionsで定義しなくてはいけない
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                            }
                                            print(model.todo);

                                            try {
                                              // todoの追加
                                              await model.updateTodoText(
                                                  id: todo.id,
                                                  text: model.todo);
                                              // TodoListsページに戻って、dialogを閉じる
                                              Navigator.pop(context);
                                            } catch (e) {
                                              print('今日する事が入力されていません');
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '本当に削除しますか？',
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () async {
                                            await model.deleteTodo(id: todo.id);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('NG'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
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
        drawer: Consumer<FirebaseTodoDomain>(
          builder: (context, model, child) {
            return Drawer(
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
                      title: Text('Incomplete'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TodoIncomplete(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Complete'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TodoComplete(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
