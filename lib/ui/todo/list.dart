import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/domain/todo_domain.dart';
import 'package:todo_app/ui/todo/complete.dart';
import 'package:todo_app/ui/todo/incomplete.dart';

class TodoList extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  // ignore: missing_return
  Color getColor(bool isCompleted) {
    if (isCompleted) {
      return Colors.amber;
    }
  }

  void verification(bool isCompleted) {
    if (isCompleted) {}
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoDomain>(
      create: (_) => TodoDomain(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('TodoLists'),
          actions: <Widget>[
            Consumer<TodoDomain>(
              builder: (context, model, child) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // todoの追加画面をダイアログで開く
                    showDialog(
                      context: context,
                      // 下記はダイアログの外側を押すとダイアログを閉じるようにするかの設定
                      // barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            '追加したいTodoを教えて！',
                            style: TextStyle(fontSize: 14),
                          ),
                          content: Form(
                            key: _formKey,
                            child: TextFormField(
                              // 複数行入力できるようにしている
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '今日する事教えてくれないの。。？';
                                }
                              },
                              onChanged: (String text) {
                                // TodoDomainのtodoフィールドに、TextFormFieldで打った文字を反映させている
                                model.todo = text;
                              },
                            ),
                          ),
                          // AlertDialogではボタン関係はactionsで定義しなくてはいけない
                          actions: <Widget>[
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState
                                      .save(); // TextFormFieldのonSavedが呼び出される
                                }
                                try {
                                  // todoの追加
                                  model.addTodo();
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
                );
              },
            )
          ],
        ),
        body: Consumer<TodoDomain>(
          builder: (context, model, child) {
            return ListView.builder(
              itemCount: model.todos.length,
              // ignore: missing_return
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    color: getColor(model.todos[index]['isCompleted']),
                    child: ListTile(
                      title: Text(
                        model.todos[index]['text'],
                        style: TextStyle(fontSize: 14),
                      ),
                      contentPadding: EdgeInsets.all(8),
                      onLongPress: () {
                        if (!model.todos[index]['isCompleted']) {
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
                                    onPressed: () {
                                      model.completeTodo(index);
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
                                        initialValue: model.todos[index]
                                            ['text'],
                                        // ignore: missing_return
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return '今日する事教えてくれないの。。？';
                                          }
                                        },
                                        onChanged: (String text) {
                                          model.todo = text;
                                        },
                                      ),
                                    ),
                                    // AlertDialogではボタン関係はactionsで定義しなくてはいけない
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState
                                                .save(); // TextFormFieldのonSavedが呼び出される
                                          }
                                          try {
                                            // todoの追加
                                            model.editTodo(index);
                                            // TodoListsページに戻って、dialogを閉じる
                                            Navigator.pop(context);
                                          } catch (e) {
                                            print('今日する事が入力されていません');
                                            if (model.todo == null) {
                                              Navigator.of(context).pop();
                                            }
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
                                        onPressed: () {
                                          model.deleteTodo(index);
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
                );
              },
            );
          },
        ),
        drawer: Consumer<TodoDomain>(builder: (context, model, child) {
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
                      // 未完了ページに飛ぶ前にDrawerを閉じている
                      Navigator.of(context).pop();
                      List incompleteTodos = model.getIncompleteTodos();
                      print(incompleteTodos);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TodoIncomplete(incompleteTodos),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Complete'),
                    onTap: () {
                      // 完了ページに飛ぶ前にDrawerを閉じている
                      Navigator.of(context).pop();
                      List completeTodos = model.getCompleteTodo();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TodoComplete(completeTodos),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
