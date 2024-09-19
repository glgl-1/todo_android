import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/model/myTodoList.dart';
import 'package:todo_app/vm/check_handler.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  // Property
  late TextEditingController editController;
  var value = Get.arguments ?? "_";

  CheckHandler checkHandler = CheckHandler();

  @override
  void initState() {
    super.initState();
    editController = TextEditingController(text: value[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '일정 수정',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: editController,
                readOnly: value[2] == 'T' ? true : false,
                onTap: () {
                  if (value[2] == 'T') {
                    errorSnackBar(
                      '완료된 일정은 수정이 불가 합니다!',
                      '',
                      Theme.of(context).colorScheme.error,
                      Theme.of(context).colorScheme.onError,
                    );
                  }
                },
                decoration: InputDecoration(
                  labelText: '수정할 내용을 입력 하세요',
                  labelStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                maxLength: 30,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('취소'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if(value[2] == 'T'){
                            showDialog('수정불가','완료된 일정은 수정이 불가 합니다.\n홈으로 돌아 갑니다.');
                          }else{
                          showDialog('수정완료','일정을 수정 하시겠습니까?');
                          }
                        },
                        child: const Text('확인'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Functions ---

  changeData() async {
    Mytodolist mytodolist = Mytodolist(
      seq: value[0],
      contents: editController.text.trim(),
    );
    if (value[2] == 'F') {
      await checkHandler.updateMyTodoList(mytodolist);
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

  showDialog(titleText, checkMessage) {
    Get.defaultDialog(
      title: titleText,
      middleText: checkMessage,
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
            changeData();
            Get.back();
            Get.back();
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