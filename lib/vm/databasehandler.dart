import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'myTodo_List.db'),
        onCreate: (db, version) async {
      await db.execute("""
        create table todolist
        (
        seq integer primary key autoincrement,
        contents text,
        checkBox text,
        insertDate date,
        finishDate date,
        deletDate Date
        )
        """);
      await db.execute("""
          create table trushtodolist(
          mytodo_seq integer,
          deletDate date,
          FOREIGN KEY(mytodo_seq) REFERENCES todolist(seq)
          )
          """);
    }, 
    version: 1
    );
  }


}// END