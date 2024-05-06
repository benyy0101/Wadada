import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wadada/common/const/colors.dart';
import 'package:textfield_tags/textfield_tags.dart';


class MultiSelectDistOption extends StatefulWidget{
  final String option_dis, optionstr_dis; //거리
  final String option_people, optionstr_people; //참여인원
  final String option_password;  // 비번
  final String option_hash; // 해시태그

  final Function(MultiSelectDistOptionState)? onStatedistUpdated;
  final Function(MultiSelectDistOptionState)? onStatepeopleUpdated;
  final Function(MultiSelectDistOptionState)? onStatepasswordUpdated;
  final Function(MultiSelectDistOptionState)? onStatehashtagUpdated;
  
  const MultiSelectDistOption({
    super.key,
    required this.option_dis,
    required this.optionstr_dis,
    required this.option_people,
    required this.optionstr_people,
    required this.option_password,
    required this.option_hash,
    this.onStatedistUpdated,
    this.onStatepeopleUpdated,
    this.onStatepasswordUpdated,
    this.onStatehashtagUpdated,
  });

  @override
  MultiSelectDistOptionState createState() => MultiSelectDistOptionState();
}

class MultiSelectDistOptionState extends State<MultiSelectDistOption> {
  double dist = 0.0;
  int distselectnum = 0;
  int peopleselectnum = 0;
  int passwordselectnum = 0;

  late double _distanceToField;

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }


  bool isPasswordMode = true; // 비밀번호 모드인지 확인하는 상태 변수
  String passwordErrorText = '비밀번호 4자리를 입력하세요.'; // 비밀번호 에러 텍스트

  void passwordUpdateErrorText() {
    // 비밀번호 유효성 검사 로직에 따라 에러 텍스트 업데이트
  }


  
  // 각 필드 입력을 위한 컨트롤러 생성
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
    // 컨트롤러들을 dispose 해주기
    distController.dispose();
    peopleController.dispose();
    passwordController.dispose();
    hashTagController.dispose();
    _stringTagController.dispose();
    super.dispose();
  }

  static const List<String> _pickLanguage = <String>[
  
  ];

  // 거리 에러 텍스트
  void distupdateErrorText() {
    final value = distController.text;
    // if (value.startsWith('0') && value.length > 1 || value.isEmpty || int.tryParse(value) == null) {
    if (value.startsWith('0') && value.length > 1) {
      disterrorText = '달릴 거리를 입력하세요.';
    } else {
      disterrorText = null;
    }

    setState(() {});
    dist = double.tryParse(value) ?? 0.0;
    if (widget.onStatedistUpdated != null) {
      widget.onStatedistUpdated!(this);
    }
  }

  // 참여인원 에러 텍스트
  void peopleupdateErrorText() {
    final value = peopleController.text;
    // if (value.startsWith('0') && value.length > 1 || value.isEmpty || int.tryParse(value) == null) {
    if (value.startsWith('0') && value.length > 1) {
      peopleerrorText = '참여인원을 입력하세요.';
    } else {
      peopleerrorText = null;
    }

    setState(() {});
    dist = double.tryParse(value) ?? 0.0;
    if (widget.onStatepeopleUpdated != null) {
      widget.onStatepeopleUpdated!(this);
    }
  }

  // 비밀번호 에러 텍스트
  void passwordupdateErrorText() {
    final value = passwordController.text;
    // if (value.startsWith('0') && value.length > 1 || value.isEmpty || int.tryParse(value) == null) {
    if (value.startsWith('0') && value.length > 1) {
      passworderrorText = '비밀방의 경우 비밀번호 숫자 4자리를 설정하세요.';
    } else {
      passworderrorText = null;
    }

    setState(() {});
    dist = double.tryParse(value) ?? 0.0;
    if (widget.onStatepeopleUpdated != null) {
      widget.onStatepeopleUpdated!(this);
    }
  }

  // 해시태그 에러 텍스트
  void hashtagupdateErrorText() {
    final value = passwordController.text;
    // if (value.startsWith('0') && value.length > 1 || value.isEmpty || int.tryParse(value) == null) {
    if (value.startsWith('0') && value.length > 1) {
      passworderrorText = '방을 소개할 단어를 입력하고 쉼표(,)를 적으면 입력되고, 최대 3개의 해시태그를 등록할 수 있어요.';
    } else {
      passworderrorText = null;
    }

    setState(() {});
    dist = double.tryParse(value) ?? 0.0;
    if (widget.onStatepeopleUpdated != null) {
      widget.onStatepeopleUpdated!(this);
    }
  }

  void _updateHashtags(dynamic value) {
    if (value is String) {
      //로직 구현
    }
  }


  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
          color: Color(0xffF6F4E9),
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
          padding: const EdgeInsets.only(left: 40, right: 40, top: 50, bottom: 70),
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
                          color: Color.fromARGB(255, 137, 137, 137),
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
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          errorText: disterrorText,
                        ),

                        controller: distController,
                        onChanged: (value) {
                          setState(() {
                              distselectnum = int.tryParse(value) ?? 0;
                              distupdateErrorText();
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.optionstr_dis,
                      style: TextStyle(
                        color: DARK_GREEN_COLOR,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )
                    )
                  ],
                ),

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
                          color: Color.fromARGB(255, 137, 137, 137),
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
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          errorText: peopleerrorText,
                        ),

                        controller: peopleController,
                        onChanged: (value) {
                          setState(() {
                              peopleselectnum = int.tryParse(value) ?? 0;
                              peopleupdateErrorText();
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.optionstr_people,
                      style: TextStyle(
                        color: DARK_GREEN_COLOR,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )
                    )
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
                    SizedBox(width: 10,),
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
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            errorText: passwordErrorText,
                          ),
                          controller: passwordController,
                          onChanged: (value) {
                            setState(() {
                              // 비밀번호 유효성 검사 및 에러 텍스트 업데이트 로직
                              passwordUpdateErrorText();
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
                              color: OATMEAL_COLOR,
                              width: 3.0,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: OATMEAL_COLOR,
                              width: 3.0,
                            )
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 74, 137, 92),
                              width: 3.0,
                            ),
                          ),
                          helperText: '단어 입력 후 쉼표를 눌러 해시태그를 등록하세요.',
                          helperStyle: const TextStyle(
                            color: Color.fromARGB(255, 167, 167, 167),
                          ),
                          errorText: inputFieldValues.error,
                          prefixIconConstraints:
                              BoxConstraints(maxWidth: _distanceToField * 0.75),
                          prefixIcon: inputFieldValues.tags.isNotEmpty
                              ? SingleChildScrollView(
                                  controller: inputFieldValues.tagScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children:
                                          inputFieldValues.tags.map((String tag) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: Color.fromARGB(255, 74, 137, 92),
                                      ),
                                      margin: const EdgeInsets.only(right: 10.0),
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
                                            onTap: () {
                                              //print("$tag selected");
                                            },
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
                                              inputFieldValues.onTagRemoved(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                                )
                              : null,
                        ),
                        onChanged: inputFieldValues.onTagChanged,
                        onSubmitted: inputFieldValues.onTagSubmitted,
                      ),
                    );
                  },
                ),
                // TextButton(
                //   style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all<Color>(
                //       GREEN_COLOR,
                //     ),
                //   ),
                //   onPressed: () {
                //     _stringTagController.clearTags();
                //   },
                //   child: const Text(
                //     '태그 지우기',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            ),
          )
        ),
    );
  }
}