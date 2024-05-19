import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:wadada/controller/multiController.dart';
import 'package:wadada/repository/multiRepo.dart';

import '../../../../../provider/multiProvider.dart';

class MultiSelectDistOption extends StatefulWidget {
  final String option_dis, optionstr_dis; //거리
  final String option_people, optionstr_people; //참여인원
  final String option_password; // 비번
  final String option_hash; // 해시태그

  const MultiSelectDistOption({
    super.key,
    required this.option_dis,
    required this.optionstr_dis,
    required this.option_people,
    required this.optionstr_people,
    required this.option_password,
    required this.option_hash,
  });

  @override
  MultiSelectDistOptionState createState() => MultiSelectDistOptionState();
}

class MultiSelectDistOptionState extends State<MultiSelectDistOption> {
  int dist = 0;
  late int distselectnum = 0;
  late int peopleselectnum = 0;
  late int passwordselectnum = 0;
  late double _distanceToField;
  double? roomDist;
  double? roomPeople;
  double? roomSecret;
  double? roomTag;
  String concatenateTags(List<String> tags) {
    // 태그 리스트 -> 하나의 문자열로
    return tags.map((tag) => '#$tag').join();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  bool isPasswordMode = true;
  String passwordErrorText = '';

  // 필드 입력 컨트롤러
  final TextEditingController distController = TextEditingController();
  final TextEditingController peopleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController hashTagController = TextEditingController();
  late StringTagController _stringTagController;

  String? disterrorText;
  String? peopleerrorText;
  String? passworderrorText;
  String? hashtagerrorText;

  @override
  void initState() {
    super.initState();
    _stringTagController = StringTagController();
  }

  @override
  void dispose() {
    distController.dispose();
    peopleController.dispose();
    passwordController.dispose();
    hashTagController.dispose();
    _stringTagController.dispose();
    super.dispose();
  }

  // 거리 에러 텍스트
  void distupdateErrorText() {
    final value = distController.text;
    if (value.startsWith('0') && value.length > 1) {
      disterrorText = '달릴 거리를 입력하세요.';
    } else {
      disterrorText = null;
      
    }

    setState(() {});
    // dist = double.tryParse(value) ?? 0.0;
  }

  // 참여인원 에러 텍스트
  void peopleupdateErrorText() {
    final value = peopleController.text;
    if (value.startsWith('0') && value.length > 1) {
      peopleerrorText = '참여인원을 입력하세요.';
    } else {
      peopleerrorText = null;
    }

    setState(() {});
    // dist = double.tryParse(value) ?? 0.0;
  }

  // 비밀번호 에러 텍스트
  void passwordupdateErrorText() {
    final value = passwordController.text;
    print("----------------------");
    print(value.length);
    if (value.length < 4) {
      passworderrorText = '비밀번호 4자리를 입력하세요.';
    } else {
      passworderrorText = null;
    }

    setState(() {});
    // dist = double.tryParse(value) ?? 0.0;
  }

  // 해시태그 에러 텍스트
  void hashtagupdateErrorText() {
    final String value = passwordController.text;
    print(value);
    print(value.length);
    if (value.startsWith('0') && value.length > 1) {
      passworderrorText =
          '방을 소개할 단어를 입력하고 쉼표(,)를 적으면 입력되고, 최대 3개의 해시태그를 등록할 수 있어요.';
    } else {
      passworderrorText = null;
    }

    setState(() {});
    // dist = double.tryParse(value) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    Get.put(MultiController(repo: MultiRepository(provider: MultiProvider())));
    return GetBuilder<MultiController>(builder: (MultiController controller) {
      return Container(
        decoration: BoxDecoration(
          color: OATMEAL_COLOR,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(1, 2),
            ),
          ],
        ),
        width: 400,
        child: Padding(
            padding:
                const EdgeInsets.only(left: 40, right: 40, top: 50, bottom: 70),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 거리
                  Text(
                    widget.option_dis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            hintText: '0',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xffe9e9e9),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xffe9e9e9),
                                width: 1.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            errorText: disterrorText,
                          ),
                          controller: distController,
                          onChanged: (value) {
                            setState(() {
                              distselectnum = int.tryParse(value) ?? 0;
                              if (widget.option_dis == '거리') {
                                controller.multiroom.roomDist = distselectnum;
                                print('거리 ${controller.multiroom.roomDist}');
                                print('거리 value $value');
                              } else if (widget.option_dis == '시간') {
                                controller.multiroom.roomTime = distselectnum;
                                print('시간 ${controller.multiroom.roomTime}');
                                print('시간 value $value');
                              }
                              // print('거리 ${controller.multiroom.roomDist}');
                              // print('거리 value $value');
                              distupdateErrorText();
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(widget.optionstr_dis,
                          style: TextStyle(
                              color: DARK_GREEN_COLOR,
                              fontSize: 20,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  if (widget.option_dis != '')
                  SizedBox(height: 40),

                  // 참여인원
                  Text(
                    widget.option_people,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            hintText: '0',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xffe9e9e9),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xffe9e9e9),
                                width: 1.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            errorText: peopleerrorText,
                          ),
                          controller: peopleController,
                          onChanged: (value) {
                            setState(() {
                              peopleselectnum = int.tryParse(value) ?? 0;
                              controller.multiroom.roomPeople = peopleselectnum;
                              print(controller.multiroom.roomPeople);
                              peopleupdateErrorText();
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(widget.optionstr_people,
                          style: TextStyle(
                              color: DARK_GREEN_COLOR,
                              fontSize: 20,
                              fontWeight: FontWeight.bold))
                    ],
                  ),

                  SizedBox(height: 40),

                  // 비밀번호
                  Row(
                    children: [
                      Text(
                        isPasswordMode ? '비밀번호' : '공개방',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Switch(
                        value: isPasswordMode,
                        onChanged: (value) {
                          setState(() {
                            isPasswordMode = value;
                          });
                        },
                        activeColor: DARK_GREEN_COLOR,
                        activeTrackColor: GREEN_COLOR,
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  if (isPasswordMode)
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 4, // 비밀번호 4자리 제한
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              hintText: '****',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xffe9e9e9),
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xffe9e9e9),
                                  width: 1.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              errorText: passwordErrorText,
                            ),
                            controller: passwordController,
                            onChanged: (value) {
                              setState(() {
                                int passwordValue = int.tryParse(value) ?? 0;
                                controller.multiroom.roomSecret = passwordValue;
                                print(controller.multiroom.roomSecret);
                                passwordupdateErrorText();
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: 40),

                  // 해시태그
                  Text(
                    widget.option_hash,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFieldTags<String>(
                    textfieldTagsController: _stringTagController,
                    textSeparators: const [' ', ','],
                    letterCase: LetterCase.normal,
                    validator: (String tag) {
                      if (_stringTagController.getTags!.length >= 3) {
                        return '해시태그는 최대 3개까지만 추가할 수 있습니다!';
                      }
                      if (tag == 'php') {
                        return '안됩니달라!';
                      } else if (_stringTagController.getTags!.contains(tag)) {
                        return '이미 입력한 단어입니다!';
                      }
                      return null;
                    },
                    inputFieldBuilder: (context, inputFieldValues) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: TextField(
                          controller: inputFieldValues.textEditingController,
                          focusNode: inputFieldValues.focusNode,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffe9e9e9),
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                              color: OATMEAL_COLOR,
                              width: 1.0,
                            )),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 74, 137, 92),
                                width: 1.0,
                              ),
                            ),
                            helperText: '단어 입력 후 쉼표를 눌러 해시태그를 등록하세요.',
                            helperStyle: const TextStyle(
                              color: Color.fromARGB(255, 167, 167, 167),
                            ),
                            errorText: inputFieldValues.error,
                            prefixIconConstraints: BoxConstraints(
                                maxWidth: _distanceToField * 0.75),
                            prefixIcon: inputFieldValues.tags.isNotEmpty
                                ? SingleChildScrollView(
                                    controller:
                                        inputFieldValues.tagScrollController,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                            contentPadding: const EdgeInsets.all(20.0),
                          ),
                          // 입력창에 뭐가 입력될 때 호출
                          onChanged: inputFieldValues.onTagChanged,
                          // 입력 완료되었을 때
                          onSubmitted: (String tag) {
                            String concatenatedTags =
                                concatenateTags(_stringTagController.getTags!);
                            controller.multiroom.roomTag = concatenatedTags;
                            print(controller.info.roomTag);
                            print('아 제발 쫌 쫌 쫌 !!!!!!!!! :$concatenatedTags');
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            )),
      );
    });
  }
}
