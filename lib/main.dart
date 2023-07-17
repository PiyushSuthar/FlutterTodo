// import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
    return MaterialApp(
      title: "Todo App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade100),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: HomePage(),
    );
    // });
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Todo> _todos = <Todo>[];
  final TextEditingController _textFieldController = TextEditingController();

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, completed: false));
      _textFieldController.clear();
    });
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.completed = !todo.completed;
    });
  }

  void _deleteTodoItem(Todo todo) {
    setState(() {
      _todos.remove(todo);
    });
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Add a Todo"),
        content: TextField(
          controller: _textFieldController,
          decoration: const InputDecoration(hintText: "Enter a Todo"),
          autofocus: true,
        ),
        actions: <Widget>[
          OutlinedButton(
              onPressed: () => {Navigator.pop(context)},
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => {
                    Navigator.pop(context),
                    _addTodoItem(_textFieldController.text)
                  },
              child: const Text("Add")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.isEmpty
            ? [
                Center(
                    child: const Text(
                  "Lol! You've Got Nothing To Do!",
                  style: TextStyle(fontSize: 17),
                ))
              ]
            : _todos.reversed
                .map((todo) => TodoItem(
                      todo: todo,
                      onTodoChanged: _handleTodoChange,
                      onTodoDeleted: _deleteTodoItem,
                    ))
                .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        tooltip: "Add a Todo",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Todo {
  Todo({required this.name, required this.completed});
  String name;
  bool completed;
}

class TodoItem extends StatelessWidget {
  TodoItem(
      {required this.todo,
      required this.onTodoChanged,
      required this.onTodoDeleted})
      : super(key: ObjectKey(todo));

  final Todo todo;

  final void Function(Todo) onTodoChanged;
  final void Function(Todo) onTodoDeleted;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(decoration: TextDecoration.lineThrough);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ObjectKey(todo),
      style: ListTileStyle.list,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      splashColor: Theme.of(context).colorScheme.secondaryContainer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      onTap: () => onTodoChanged(todo),
      leading: Checkbox(
          value: todo.completed,
          onChanged: (value) {
            onTodoChanged(todo);
          }),
      title: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            todo.name,
            style: _getTextStyle(todo.completed),
          )),
          IconButton(
            onPressed: () {
              onTodoDeleted(todo);
            },
            iconSize: 30,
            icon: const Icon(Icons.delete),
            alignment: Alignment.centerRight,
          )
        ],
      ),
    );
  }
}
