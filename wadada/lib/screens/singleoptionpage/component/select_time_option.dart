import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wadada/common/const/colors.dart';

class SelectTimeOption extends StatefulWidget{
  final String option, optionstr;
  final Function(SelectTimeOptionState)? onStateUpdated;
  
  const SelectTimeOption({
    super.key,
    required this.option,
    required this.optionstr,
    this.onStateUpdated,
  });

  @override
  SelectTimeOptionState createState() => SelectTimeOptionState();
}

class SelectTimeOptionState extends State<SelectTimeOption> {
  int time = 0;
  int timeselectnum = 0;
  final TextEditingController timecontroller = TextEditingController();
  String? errorText;
  bool isError = false;

  void updateErrorText() {
    final value = timecontroller.text;

    if (value.startsWith('0') && value.length > 1 || value.isEmpty || int.tryParse(value) == null || int.tryParse(value) == 0) {
        errorText = '정수 값을 입력하세요.';
        isError = true;
    } else if (double.tryParse(value) != null && double.parse(value) > 1440.0) {
        errorText = '24시간 이내의 값만 입력하세요.';
        isError = true;
    } else {
        errorText = null;
        isError = false;
        time = int.tryParse(value) ?? 0;
    }

    setState(() {});

    if (widget.onStateUpdated != null) {
      widget.onStateUpdated!(this);
      print('onStateUpdated called: isError = $isError');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.option,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: 150,
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
                      errorText: errorText,
                    ),
                    // textAlign: TextAlign.center,
                    controller: timecontroller,
                    onChanged: (value) {
                      setState(() {
                          timeselectnum = int.tryParse(value) ?? 0;
                          updateErrorText();
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  widget.optionstr,
                  style: TextStyle(
                    color: DARK_GREEN_COLOR,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}