import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/myTodoList.dart';
import 'package:todo_app/vm/databasehandler.dart';

final DatabaseHandler databaseHandler = DatabaseHandler();

class QueryHandler {

  // 일정추가
  Future<int> insertMyTodoList(Mytodolist myTodoList) async {
    int result = 0;
    final Database db = await databaseHandler.initializeDB();
    result = await db.rawInsert(
      """
      insert into todolist(
      contents,
      checkBox,
      insertDate
      )
      values(?,'F',?)
      """,[
        myTodoList.contents,
        DateTime.now().toLocal().toString()
        ]
    );
    return result;
  }

  // 검색
  Future<List<Mytodolist>> queryTodoList()async{
    final Database db = await databaseHandler.initializeDB();
    final List<Map<String, Object?>> queryTodoList =
    await db.rawQuery(
      """
      select *
      from todolist
      where deletDate is null
      """
    );
    return queryTodoList.map((e)=> Mytodolist.fromMap(e)).toList();
  }


// 완료일정검색
Future<List<Mytodolist>> finishTodoList() async {
  final Database db = await databaseHandler.initializeDB();
  final List<Map<String, Object?>> queryTodoList =
      await db.rawQuery(
        """
        select *
        from todolist
        where finishDate is not null
        and deletDate is null
        """
      );
  return queryTodoList.map((e) => Mytodolist.fromMap(e)).toList();
}


// 미완료일정검색
Future<List<Mytodolist>> notfinishTodoList() async {
  final Database db = await databaseHandler.initializeDB();
  final List<Map<String, Object?>> queryTodoList =
      await db.rawQuery(
        """
        select *
        from todolist
        where finishDate is null
        and deletDate is null
        """
      );
  return queryTodoList.map((e) => Mytodolist.fromMap(e)).toList();
}




}// END
