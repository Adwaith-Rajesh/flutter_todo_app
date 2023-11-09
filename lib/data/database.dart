import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List todoList = [];
  final _todoBox = Hive.box('todo_box');

  // run this methods if this the first time ever we are opening the app
  void createInitialDate() {
    todoList = [
      ['Create a new task', false],
    ];
  }

  void loadDate() {
    todoList = _todoBox.get('TODOLIST');
  }

  void updateDateBase() {
    _todoBox.put('TODOLIST', todoList);
  }
}
