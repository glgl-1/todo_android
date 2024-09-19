import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/myTodoList.dart';
import 'package:todo_app/vm/databasehandler.dart';

DatabaseHandler databaseHandler = DatabaseHandler();

class SearchHandler {
  Future<List<Mytodolist>> serchTodoList(String searchText) async {
    final Database db = await databaseHandler.initializeDB();
    final List<Map<String, Object?>> serchquery = await db.rawQuery(
      """
      SELECT * 
      FROM todolist 
      WHERE deletDate is null 
      and contents LIKE ?
      """, ['%$searchText%']
    );
    
    return serchquery.map((e) => Mytodolist.fromMap(e)).toList();
  }
}
