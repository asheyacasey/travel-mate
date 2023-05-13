import 'package:hive_flutter/hive_flutter.dart';

class JournalDatabase {
  List posts = [];

  final _mybox = Hive.box('mybox');

  //run this method if first time opening the app
  void createInitialData() {
    posts = [
      [
        "I love drinking coffee by the beach. This make me feel calm while watching the waves crash by"
      ],
      [
        "I love watching movies and my experience in the Director's Club made me love movies even more"
      ],
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
