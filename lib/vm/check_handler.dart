import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/myTodoList.dart';
import 'package:todo_app/vm/databasehandler.dart';
import 'package:todo_app/vm/query_handler.dart';

final DatabaseHandler handler = DatabaseHandler();

class CheckHandler {
  // 일정완료 or 취소
  Future<int> checkBoxUpdate(String checkBoxValue, int seq) async {
    int result = 0;
    final Database db = await databaseHandler.initializeDB();
    String? finishDateValue = checkBoxValue == 'T'
        ? DateTime.now().toLocal().toString()
        : null; 
    result = await db.rawUpdate("""
    update todolist set checkBox = ?, 
    finishDate = ?
    where seq = ?
    """, [checkBoxValue, finishDateValue, seq] 
        );
    return result;
  }

  // 일정수정
  Future<int> updateMyTodoList(Mytodolist mytodoList) async {
    int result = 0;
    final Database db = await databaseHandler.initializeDB();
    result = await db.rawUpdate("""
    update todolist set contents = ?, 
    insertDate = ? 
    where seq = ?
    """, [
      mytodoList.contents,
      DateTime.now().toLocal().toString(),
      mytodoList.seq
      ]
    );
    return result;
  }

  
}// END