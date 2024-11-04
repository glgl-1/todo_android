import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/trush_todo.dart';
import 'package:todo_app/vm/databasehandler.dart';
import 'package:todo_app/vm/query_handler.dart';

DatabaseHandler handler = DatabaseHandler();

class TrushHandler {
  // 삭제날짜 추가
  Future<int> trushUpdate(int seq) async {
  int result = 0;
  final Database db = await databaseHandler.initializeDB();
  result = await db.rawUpdate(
    """
    update todolist set deletDate = ?
    where seq = ?
    """,
    [
    DateTime.now().toLocal().toString(), 
    seq
    ] 
  );
  return result;
}


  // 쓰레기통에 추가
Future<int> insertTrushTodo(TrushTodo trush_todo) async {
  int result = 0;
  final Database db = await databaseHandler.initializeDB();
  result = await db.rawInsert(
    """
    insert into trushtodolist (mytodo_seq, deletDate)
    values (?, ?)
    """, 
      [
      trush_todo.mytodo_seq,
      DateTime.now().toLocal().toString()
      ]
  );
  return result;
}


  //쓰레기통 전체보기
Future<List<TrushTodo>> queryTrushTodoList() async {
  final Database db = await databaseHandler.initializeDB();
  final List<Map<String, Object?>> queryTrushTodoList = await db.rawQuery("""
    select r.mytodo_seq, t.contents, r.deletDate
    from trushtodolist r, todolist t
    where r.mytodo_seq = t.seq
  """);
  return queryTrushTodoList.map((e) => TrushTodo.fromMap(e)).toList();
}

  // 삭제
  Future<void> deletTodoList(int seq)async{
    final Database db = await databaseHandler.initializeDB();
    await db.rawDelete(
      """
      delete from todolist where seq = ?
      """,[seq]
    );
  }
  
// 복구
Future<void> recoveryTodoList(int todoSeq) async {
  final Database db = await databaseHandler.initializeDB();
  await db.rawUpdate('''
    update todolist
    set deletDate = NULL
    where seq = ?
  ''', [todoSeq]);
}

Future<void> deleteFromTrash(int todoSeq) async {
  final Database db = await databaseHandler.initializeDB();
  await db.rawDelete(
    """
    delete from trushtodolist where mytodo_seq = ?
    """, [todoSeq]
  );
}




  
}// END