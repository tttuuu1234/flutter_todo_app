import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/domain/todo_domain.dart';

class TodoList extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  // finalを付けないと警告が出る
  // でもfinalをつけるとこのファイルはstatelesswidgeだから_todoの値の変更はできないよと言われる
  // だらかこのファイルをstatefullに変えて、setstateで値のfinalの定数の値を更新できるようにしてあげる
  // でもそれは面倒だから、EntityModelとProviderを用意して
  // EntityModelの定義したfinalのtodoの値を更新して、providerでその変更を受け取れるようにして、TodoListsページに表示させる感じかな？

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoDomain>(
      create: (_) => TodoDomain(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('TodoLists'),
          actions: <Widget>[
            Consumer<TodoDomain>(builder: (context, model, child) {
              return IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  print('todo追加画面開いたよ');
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
            })
          ],
        ),
        body: Consumer<TodoDomain>(
          builder: (context, model, child) {
            return ListView.builder(
              itemCount: model.todos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // RowやColumeの中でFlexibleは使う
                        Flexible(
                          child: Text(
                            model.todos[index],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
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
      ),
    );
  }
}
