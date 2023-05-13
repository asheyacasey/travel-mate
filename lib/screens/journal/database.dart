import 'package:hive_flutter/hive_flutter.dart';

class JournalDatabase {
  List posts = [];

  final _mybox = Hive.box('mybox');

  //run this method if first time opening the app
  void createInitialData() {
    posts = [
      ["post 1"],
      ["post 2"],
    ];
  }

  //load the data from database
  void loadData() {
    posts = _mybox.get("POSTS");
  }

  //update the database
  void updateDatabase() {
    _mybox.put("POSTS", posts);
  }
}
