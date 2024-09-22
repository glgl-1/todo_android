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
          title: const Text(
            '휴지통',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
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
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              if (checkBoxList.length != snapshot.data!.length) {
                checkBoxList =
                    List.generate(snapshot.data!.length, (index) => false);
              }
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
                              selectTodo
                                  .remove(snapshot.data![index].mytodo_seq);
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
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // 데이터 로딩 중일 때
            } else {
              return const Center(
                child: Text(
                  '휴지통이 비어 있습니다.',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
              ); // 데이터가 없을 때
            }
          },
        ));
  }

  // --- Functions ---

  deletAllTodo() async {
    for (int i = 0; i < selectTodo.length; i++) {
      await trushHandler.deletTodoList(selectTodo[i]);
    }
    selectTodo.clear();
    await reloadData();
    setState(() {});
  }

  recoveryTodo() async {
    for (int i = 0; i < selectTodo.length; i++) {
      await trushHandler.recoveryTodoList(selectTodo[i]);
      await trushHandler.deleteFromTrash(selectTodo[i]);
    }
    selectTodo.clear();
    await reloadData();
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
            if (titleText == '선택한 일정 복구하기') {
              recoveryTodo();
              setState(() {});
              Get.back();
            } else {
              deletAllTodo();
              Get.back();
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
}// END
