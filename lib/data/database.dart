import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];

  //reference
  final _myBox = Hive.box('mybox');

  //run this if first time opening the app
  void createInitialData() {
    toDoList = [
      ['Make Tutorial', false],
      ['Do Exercise', true],
    ];
  }

  //load the data from the data base
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  //load data from the database
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
