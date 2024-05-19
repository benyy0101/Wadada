import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:wadada/controller/multiController.dart';
import 'package:wadada/models/multiroom.dart';
import 'package:wadada/provider/multiProvider.dart';
import 'package:wadada/repository/multiRepo.dart';
import 'package:wadada/screens/multimainpage/multi_distance/multi_waitingpage/multi_dis_room_detail.dart';
import 'package:wadada/screens/multimainpage/multi_distance/multi_waitingpage/multi_dis_roomcard.dart';
import 'package:wadada/screens/multimainpage/multi_distance/multi_waitingpage/multi_dist_room_form.dart';

class MultiDisWait extends StatefulWidget {
  int roomMode;

  MultiDisWait({super.key, required this.roomMode});

  @override
  _MultiDisWait createState() => _MultiDisWait(roomMode: roomMode);
}

class _MultiDisWait extends State<MultiDisWait> {
  int roomMode;

  _MultiDisWait({required this.roomMode});

  final controller = Get.put(
      MultiController(repo: MultiRepository(provider: MultiProvider())));

  @override
  void initState() {
    super.initState();
  }

  void validatePassword(SimpleRoom room, BuildContext context) {
    final formKey = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        bool isPasswordCorrect = true;
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Color(0xffD6D6D6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  '비밀번호',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50),
                Form(
                  key: formKey,
                  child: TextFormField(
                    obscuringCharacter: '*',
                    maxLength: 4,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Hide the entered text
                    decoration: InputDecoration(
                      hintText: '4자리 비밀번호를 입력해 주세요',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      print('`````````````````````');
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해 주세요';
                      } else if (value.length != 4 ||
                          !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return '비밀번호는 4자리 입니다';
                      } else if (value != room.roomSecret.toString()) {
                        return '비밀번호가 일치하지 않습니다';
                      } else {
                        Navigator.pop(context);
                        Get.to(() => MultiRoomDetail(roomInfo: room));
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value == room.roomSecret) {
                        isPasswordCorrect = true;
                        Get.to(() => MultiRoomDetail(roomInfo: room));
                      } else {
                        isPasswordCorrect = false;
                      }
                      print("---------------------------");
                      print(value);
                      print(isPasswordCorrect);
                    },
                    onSaved: (newValue) {
                      print("HI");
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: GREEN_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(400, 40),
                  ),
                  onPressed: () {
                    final formKeyState = formKey.currentState!;
                    print("+++++++++++++++++++++");
                    formKeyState.validate();
                    if (formKeyState.validate()) {
                      print("=========================");
                      formKeyState.save();
                    }
                  },
                  child: const Text('확인'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    late String titleText = '';
    StringTagController tagController = StringTagController();
    // controller.getMultiRoomsByMode(1);
    print('roomMode------------------------------');
    print(roomMode);
    if (roomMode == 1) {
      titleText = '거리모드 - 멀티';
    } else if (roomMode == 2) {
      titleText = '시간모드 - 멀티';
    } else {
      titleText = '만남모드 - 멀티';
    }

    String concatenateTags(List<String> tags) {
      // 태그 리스트 -> 하나의 문자열로
      return tags.map((tag) => tag).join(' ');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText, style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 20), // Add padding to the bottom to avoid overflow
            child: Column(
              children: [
                // Rest of your content
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.to(MultiDistanceRoomForm(
                          roomMode: roomMode,
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: GREEN_COLOR,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(90, 40),
                      ),
                      child: const Text('방 생성하기'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldTags<String>(
                        textfieldTagsController: tagController,
                        textSeparators: const [' ', ','],
                        letterCase: LetterCase.normal,
                        validator: (String tag) {
                          if (tagController.getTags!.length >= 3) {
                            return '해시태그는 최대 3개까지만 추가할 수 있습니다!';
                          }
                          if (tag == 'php') {
                            return '안됩니달라!';
                          } else if (tagController.getTags!.contains(tag)) {
                            return '이미 입력한 단어입니다!';
                          }
                          return null;
                        },
                        inputFieldBuilder: (context, inputFieldValues) {
                          inputFieldValues.onTagChanged;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: TextField(
                              controller:
                                  inputFieldValues.textEditingController,
                              focusNode: inputFieldValues.focusNode,
                              decoration: InputDecoration(
                                hintText: tagController.getTags == null ||
                                        tagController.getTags!.isEmpty
                                    ? '해시태그를 입력하세요'
                                    : null,
                                filled: true,
                                fillColor: Colors.white,
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color(0xffe9e9e9),
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: GRAY_400,
                                      width: 1.0,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 74, 137, 92),
                                    width: 1.0,
                                  ),
                                ),
                                helperStyle: const TextStyle(
                                  color: Color.fromARGB(255, 167, 167, 167),
                                ),
                                errorText: inputFieldValues.error,
                                prefixIconConstraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.75),
                                prefixIcon: inputFieldValues.tags.isNotEmpty
                                    ? SingleChildScrollView(
                                        controller: inputFieldValues
                                            .tagScrollController,
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: Row(
                                              children: inputFieldValues.tags
                                                  .map((String tag) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                                color: DARK_GREEN_COLOR,
                                              ),
                                              margin: const EdgeInsets.only(
                                                  right: 10.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 4.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    child: Text(
                                                      '#$tag',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onTap: () {},
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  InkWell(
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      size: 14.0,
                                                      color: Color.fromARGB(
                                                          255, 233, 233, 233),
                                                    ),
                                                    onTap: () {
                                                      inputFieldValues
                                                          .onTagRemoved(tag);
                                                    },
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList()),
                                        ))
                                    : null,
                                contentPadding: const EdgeInsets.all(15.0),
                              ),
                              // 입력창에 뭐가 입력될 때 호출
                              onChanged: (value) {
                                inputFieldValues.onTagChanged(value);
                                print("----------------------");
                                controller.keyword.value =
                                    concatenateTags(inputFieldValues.tags);
                                controller.roomSearch(roomMode);
                                // if (tagController.getTags != null) {

                                // }
                              },
                              // 입력 완료되었을 때
                              onSubmitted: (String tag) {
                                String concatenatedTags =
                                    concatenateTags(tagController.getTags!);
                                controller.multiroom.roomTag = concatenatedTags;
                                print(controller.info.roomTag);
                                print(
                                    '아 제발 쫌 쫌 쫌 !!!!!!!!! :$concatenatedTags');
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                Obx(() {
                  if (controller.roomList.isEmpty) {
                    controller.getMultiRoomsByMode(roomMode);
                  }
                  if (controller.roomList.isEmpty) {
                    return Column(children: const [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        '현재 방이 없습니다.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ]);
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.roomList.length,
                        itemBuilder: (context, idx) {
                          return GestureDetector(
                              onTap: () {
                                // validatePassword(
                                //     controller.roomList[idx], context);
                                Get.to(() => MultiRoomDetail(
                                    roomInfo: controller.roomList[idx]));
                              },
                              child: Column(children: [
                                const SizedBox(height: 30),
                                DisRoomInfoCard(
                                    roomInfo: controller.roomList[idx]),
                              ]));
                        });
                  }
                }),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class CustomSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const CustomSearchField({
    super.key,
    required this.controller,
    this.hintText = 'Enter your search query',
  });

  @override
  _CustomSearchFieldState createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          hintText: widget.hintText,
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Colors
                    .green), // Assuming GREEN_COLOR is defined as Colors.green
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        onTap: () {
          _focusNode
              .requestFocus(); // Manually request focus when the text field is tapped
        },
      ),
    );
  }
}
