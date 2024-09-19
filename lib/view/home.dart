import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/trush_todo.dart';
import 'package:todo_app/view/edit_page.dart';
import 'package:todo_app/view/remove_page.dart';
import 'package:todo_app/vm/check_handler.dart';
import 'package:todo_app/vm/query_handler.dart';
import 'package:todo_app/vm/serch_handler.dart';
import 'package:todo_app/vm/trush_handler.dart';
import '../model/myTodoList.dart';

class Home extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const Home({super.key, required this.onChangeTheme});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Property
  late TextEditingController controller; // 입력창
  late bool checkBox; // 완료여부에 필요한 체크박스
  late bool isDarkMode; // Light & Dark Mode Change
  late List<String> items; // dropdown item
  late String dropdownvalue;
  late String search;

  QueryHandler queryHandler = QueryHandler();
  TrushHandler trushHandler = TrushHandler();
  CheckHandler checkHandler = CheckHandler();
  SearchHandler searchHandler = SearchHandler();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    checkBox = false;
    isDarkMode = false;
    items = ['All', '완료', '미완료'];
    dropdownvalue = 'All';
    search = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘 잊은거 없나?'),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              Get.to(
                () => const RemovePage(),
              )!.then((value) => reloadData(),);
            },
            icon: const Icon(Icons.delete_forever_outlined),
          ),
          IconButton(
            onPressed: () {
              _chageThemMode(); // Dark & Light mode Change
            },
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
          ),
          IconButton(
            onPressed: () {
              buttonDialog();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1, // 화면 높이의 10%
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                              value: dropdownvalue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: items.map(
                                (String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              onChanged: (value) {
                                dropdownvalue = value!;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8, 
                child: FutureBuilder(
                  future:dropdownvalue == '완료'
                          ? queryHandler.finishTodoList() // 드롭다운에서 '완료' 선택 시
                          : dropdownvalue == '미완료'
                              ? queryHandler.notfinishTodoList() // 드롭다운에서 '미완료' 선택 시
                              : queryHandler.queryTodoList(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          '등록된 일정이 없습니다\n 일정을 추가해 주세요',
                          style: TextStyle(fontSize: 18.0, color: Colors.grey),
                        ),
                      );
                    } 
                    else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => const EditPage(), arguments: [
                                snapshot.data![index].seq,
                                snapshot.data![index].contents,
                                snapshot.data![index].checkBox,
                                snapshot.data![index].insertDate
                              ])!.then((value) => reloadData(),);
                            },
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                    value:snapshot.data![index].checkBox == 'T',
                                    onChanged: (value) {
                                      _finishTodo(value, snapshot.data![index]);
                                      setState(() {});
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${snapshot.data![index].contents}',
                                      style: TextStyle(
                                        decoration: snapshot.data![index].checkBox == 'T'
                                                ? TextDecoration.lineThrough
                                                : null,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '등록 : ${DateFormat.yMMMd().add_jm().format(DateTime.parse(snapshot.data![index].insertDate.toString()))}',
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            snapshot.data![index].checkBox ==
                                                'T',
                                        child: Text(
                                          snapshot.data![index].checkBox == 'T'
                                              ? '완료 : ${DateFormat.yMMMd().add_jm().format(DateTime.parse(snapshot.data![index].finishDate.toString()))}'
                                              : '미완료',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      makedeletDate(snapshot.data![index].seq!);
                                      // moveToTrush(snapshot.data![index].seq!);
                                      showDialog('삭제하기', '휴지통에 넣으시겠습니까?', '삭제');
                                    },
                                    icon:
                                        const Icon(Icons.delete_sweep_outlined),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Functions ---
  reloadData() {
    setState(() {});
  }

  // 삭제날짜 생성
  makedeletDate(index) async {
    await trushHandler.trushUpdate(index);
    moveToTrush(index);
  }

  // 쓰레기통으로 이동
  moveToTrush(index) async {
    TrushTodo trushTodo = TrushTodo(mytodo_seq: index);
    await trushHandler.insertTrushTodo(trushTodo);
  }

  addData() async {
    Mytodolist mytodolist = Mytodolist(
      contents: controller.text.trim(),
    );
    await queryHandler.insertMyTodoList(mytodolist);
  }

  _chageThemMode() {
    // Mode Change
    isDarkMode = !isDarkMode;
    widget.onChangeTheme(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  _finishTodo(value, Mytodolist mytodo) async {
    String checkBox = value ? 'T' : 'F';
    CheckHandler checkHandler = CheckHandler();
    await checkHandler.checkBoxUpdate(checkBox, mytodo.seq!);
    if (value) {
      errorSnackBar(
        '일정이 완료되었습니다!',
        '완료된 일정은 완료일정탭에서도 확인이 가능합니다.',
        Theme.of(context).colorScheme.tertiaryContainer,
        Theme.of(context).colorScheme.onTertiaryContainer,
      );
    } else {
      errorSnackBar(
        '일정 완료표기가 취소되었습니다!',
        '',
        Theme.of(context).colorScheme.error,
        Theme.of(context).colorScheme.onError,
      );
    }
    setState(() {});
  }

  errorSnackBar(deletMessage, memoMessage, titleColor, textColor) {
    // 파라미터를 이용하여 에러스넥바 데이터 비었을때 삭제됬을떄 알림
    Get.snackbar(deletMessage, memoMessage,
        snackPosition: SnackPosition.BOTTOM, // snackBar 나오는 위치
        duration: const Duration(seconds: 1), // 유지되는 시간
        backgroundColor: titleColor, // snackBar 색
        colorText: textColor // 스넥바 글씨
        );
  }

  buttonDialog() {
    // 일정추가할때
    Get.defaultDialog(
      title: "새로운 일정 추가하기",
      middleText: "추가할 일정을 입력해 주세요",
      barrierDismissible: false,
      actions: [
        Column(
          children: [
            SizedBox(
              width: 330,
              child: TextField(
                maxLength: 30,
                controller: controller,
                decoration: InputDecoration(
                  labelText: '할 일을 추가해주세요',
                  labelStyle: const TextStyle(
                    fontSize: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  controller.text = '';
                  Get.back();
                },
                child: const Text('취소'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isEmpty) {
                    Get.back();
                    errorSnackBar(
                      "입력이되지 않았습니다",
                      "할일을 추가해 주세요",
                      Theme.of(context).colorScheme.error,
                      Theme.of(context).colorScheme.onError,
                    );
                  } else {
                    addData();
                    Get.back();
                    controller.text = '';
                    errorSnackBar(
                      '새로운 일정이 추가되었습니다!',
                      '잊지말고 완료해주세요!',
                      Theme.of(context).colorScheme.tertiaryContainer,
                      Theme.of(context).colorScheme.onTertiaryContainer,
                    );
                  }
                  setState(() {});
                },
                child: const Text('추가'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  showDialog(titleText, checkMessage, checkplan) {
    // 데이터유무 체크 후 showDialog를 통해 데이터 추가
    Get.defaultDialog(
      title: titleText,
      middleText: checkMessage,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            if (checkplan == '일정추가') {
              Get.back();
            }else{
              Get.back();
            }
            setState(() {});
          },
          child: const Text(
            '취소',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () {
            if (checkplan == '삭제') {
              Get.back();
              errorSnackBar(
                '삭제완료',
                '선택한 일정이 휴지통으로 이동 되었습니다',
                Theme.of(context).colorScheme.error,
                Theme.of(context).colorScheme.onError,
              );
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
} // END
