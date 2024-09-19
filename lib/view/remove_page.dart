import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/vm/trush_handler.dart';

class RemovePage extends StatefulWidget {
  const RemovePage({super.key});

  @override
  State<RemovePage> createState() => _SecondPageState();
}

class _SecondPageState extends State<RemovePage> {
// Property
  TrushHandler trushHandler = TrushHandler();

  late List<bool> checkBoxList;
  late List<int> selectTodo;

  @override
  void initState() {
    super.initState();
    selectTodo = [];
    checkBoxList = [];
    reloadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('휴지통'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog('선택한 일정 복구하기', '선택한 일정을 복구 하시겠습니까??', '복구하기');
            }, 
            icon: const Icon(Icons.replay)),
          IconButton(
            onPressed: () {
              showDialog('선택한 일정 삭제하기', '선택한 일정을 삭제하시겠습니까?', '전체삭제');
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: FutureBuilder(
        future: trushHandler.queryTrushTodoList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: checkBoxList[index],
                        onChanged: (value) {
                          checkBoxList[index] = value!;
                          if (checkBoxList[index]) {
                            selectTodo.add(snapshot.data![index].mytodo_seq);
                          } else {
                            selectTodo.remove(snapshot.data![index].mytodo_seq);
                          }
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: Text(
                          snapshot.data![index].contents.toString(),
                        ),
                      ),
                      Text(
                        '삭제날짜 : ${snapshot.data![index].deletDate.toString()}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Text('휴지통이 비어 있습니다.');
          }
        },
      ),
    );
  }

  // --- Functions ---

  deletAllTodo() async {
  for (int i = 0; i < selectTodo.length; i++) {
    await trushHandler.deletTodoList(selectTodo[i]);
  }
  selectTodo.clear();
}

recoveryTodo() async {
  for (int i = 0; i < selectTodo.length; i++) {
    await trushHandler.recoveryTodoList(selectTodo[i]);
    await trushHandler.deleteFromTrash(selectTodo[i]);
  }

  selectTodo.clear();
  setState(() {});
}


  reloadData() async {
    var data = await trushHandler.queryTrushTodoList();
    checkBoxList = List.generate(data.length, (index) => false);
    setState(() {});
  }

  showDialog(titleText, checkmessage, delet) {
    Get.defaultDialog(
      title: titleText,
      middleText: checkmessage,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            '아니오',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () {
            if(titleText == '선택한 일정 복구하기'){
              recoveryTodo();
              setState(() {});
              Get.back();
            }else{
            deletAllTodo();
            Get.back();
            // errorSnackBar(
            //   '삭제완료',
            //   '선택한 일정이 삭제되었습니다',
            //   Theme.of(context).colorScheme.error,
            //   Theme.of(context).colorScheme.onError,
            // );
            }
            setState(() {});
          },
          child: const Text(
            '네',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  // errorSnackBar(deletMessage, memoMessage, titleColor, textColor) {
  //   // 파라미터를 이용하여 에러스넥바 데이터 비었을때 삭제됬을떄 알림
  //   Get.snackbar(deletMessage, memoMessage,
  //       snackPosition: SnackPosition.BOTTOM, // snackBar 나오는 위치
  //       duration: const Duration(seconds: 1), // 유지되는 시간
  //       backgroundColor: titleColor, // snackBar 색
  //       colorText: textColor // 스넥바 글씨
  //       );
  // }

}// END
