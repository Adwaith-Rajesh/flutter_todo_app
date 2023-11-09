import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/utils/dialog_box.dart';
import 'package:todo_app/utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controller
  final _newTask = TextEditingController();

  final _todoBox = Hive.box('todo_box');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // check if this is the first time opening the app
    if (_todoBox.get('TODOLIST') == null) {
      db.createInitialDate();
    } else {
      // already some data exists
      db.loadDate();
    }

    super.initState();
  }

  void _checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDateBase();
  }

  void _saveNewTask() {
    Navigator.of(context).pop();

    if (_newTask.text == '') {
      return;
    }

    setState(() {
      db.todoList.add([_newTask.text, false]);
      _newTask.clear();
    });
    db.updateDateBase();
  }

  void _createNewTask() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        controller: _newTask,
        onSave: _saveNewTask,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDateBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TO DO'),
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.todoList[index][0],
            taskCompleted: db.todoList[index][1],
            onChanged: (value) => _checkBoxChanged(value, index),
            deleteFunction: (context) => _deleteTask(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
